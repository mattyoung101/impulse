// This file is part of Impulse, the retro FPGA music synthesizer
// Copyright (c) 2022 Matt Young. All rights reserved.

// Noise oscillator testbench
`timescale 1ns/1ns

module osc_noise_tb();
    logic clk, rst, en;
    logic signed[16:0] sample;
    logic[16:0] crush; // output logic

    osc_noise osc(clk, rst, en, sample, crush);

    initial begin
        $display("[osc_noise_tb] starting noise osc testbench");
        $dumpfile("osc_noise.vcd");
        $dumpvars;
        
        // device parameters
        en = 1;
        crush = 16'd10; // new sample every 10 ticks

        // reset the device
        rst = 1;
        #10;
        rst = 0;
        #10;

        // clock parameters:
        // 44.1 KHz (audio clock) is 22675.737 nanoseconds ~= 22676 nanoseconds
        // 1 MHz (system clock?) is 1000 nanoseconds

        // start the clock
        clk = 0;
        for (int i = 0; i < 1000; i++) begin
            clk = ~clk;
            #10;
        end
    end
endmodule