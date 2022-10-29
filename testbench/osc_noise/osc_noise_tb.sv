// This file is part of Impulse, the retro music FPGA synthesizer.
// Copyright (c) 2022 Matt Young. All rights reserved.

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0

// Noise oscillator testbench
`timescale 1ns/1ns

module osc_noise_tb();
    logic clk, rst, en;
    logic signed[16:0] sample, volume;
    logic [16:0] period;
    int fd;

    osc_noise osc(clk, rst, en, volume, sample, period);

    initial begin
        $display("[osc_noise_tb] Starting noise oscillator testbench");
        $dumpfile("osc_noise.vcd");
        $dumpvars;
        fd = $fopen("osc_noise.txt", "wb");
        
        // device parameters
        en = 1;
        period = 16'd1;
        volume = 16'd16384;

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

        // check enable works
        en = 0;
        // reset the device
        rst = 1;
        #10;
        rst = 0;
        #10;
        for (int i = 0; i < 44_100; i++) begin
            clk = 1;
            #11338;
            clk = 0;
            #11338;
            $fwrite(fd, "%d\n", $signed(sample));
        end

        // check volume control and period works works
        en = 1;
        volume = 16'd1024;
        period = 16'd64;
        // reset the device
        rst = 1;
        #10;
        rst = 0;
        #10;
        for (int i = 0; i < 44_100; i++) begin
            clk = 1;
            #11338;
            clk = 0;
            #11338;
            $fwrite(fd, "%d\n", $signed(sample));
        end

        $fclose(fd);
        $display("[osc_noise_tb] Done");
    end
endmodule