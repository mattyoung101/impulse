// This file is part of Impulse, the retro FPGA music synthesizer
// Copyright (c) 2022 Matt Young. All rights reserved.

// Noise oscillator testbench
`timescale 1ns/1ns

module osc_noise_tb();
    logic clk, rst, en;
    logic signed[16:0] sample;
    logic[16:0] period;
    int fd;

    osc_noise osc(clk, rst, en, sample, period);

    initial begin
        $display("[osc_noise_tb] Starting noise oscillator testbench");
        $dumpfile("osc_noise.vcd");
        $dumpvars;
        fd = $fopen("osc_noise.txt", "wb");
        
        // device parameters
        en = 1;
        period = 16'd1;

        // reset the device
        rst = 1;
        #10;
        rst = 0;
        #10;

        // clock parameters:
        // 44.1 KHz (audio clock) is 22675.737 nanoseconds ~= 22676 nanoseconds
        // = 11337.8685 nanoseconds per edge (~= 11338 nanoseconds per edge)

        // generate 1 second of audio @ 44.1 KHz (therefore 44100 samples)
        for (int i = 0; i < 44_100; i++) begin
            clk = 1;
            #11338;
            clk = 0;
            #11338; // as mentioned above, 44.1 KHz clock
            $fwrite(fd, "%d\n", $signed(sample)); // TODO figure out some way to write this as binary
        end

        $fclose(fd);
        $display("[osc_noise_tb] Done");
    end
endmodule