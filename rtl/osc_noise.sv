// This file is part of Impulse, the retro music FPGA synthesizer
// Copyright (c) 2022 Matt Young. All rights reserved.

// Noise oscillator for Impulse
// This oscillator is based on a 16-bit maximal-period LFSR, sourced from:
// https://en.wikipedia.org/wiki/Linear-feedback_shift_register#Example_polynomials_for_maximal_LFSRs
// taps are 16, 15, 13, 4

module osc_noise(
    // AUDIO PARAMS
    // clock line to generate noise samples
    input logic clk,
    // true if we should reset
    input logic rst,
    // true if oscillator is enabled
    input logic en,
    // 16-bit signed audio sample
    output logic signed[16:0] sample,

    // OSCILLATOR PARAMS
    // bitcrush factor: wait this many samples before updating the noise value 
    input logic[16:0] crush
);
    // current counter between samples (via "crush")
    logic [16:0] counter = 0;
    // LFSR value
    logic [16:0] lfsr = 16'hACE1;

    // reset circuit
    always_ff @(posedge rst) begin
        counter <= 0;
        lfsr <= 16'hACE1;
        $display("[osc_noise] reset");
    end

    always_ff @(posedge clk) begin
        // we really need combinatorial logic in here somehow
        if (counter >= crush) begin
            // "crush" time has elapsed, time to generate a sample
            // lfsr <= lfsr[15] ^~ lfsr[14] ^~ lfsr[12] ^~ lfsr[3];
            counter <= 0;
            $display("[osc_noise] new sample, counter = %d, crush = %d, lfsr = 0x%X", counter, crush, lfsr);
        end else begin
            // counter update has to be here, otherwise it doesn't work as it should
            // TODO try to figure out why the above?
            // maybe each non-blocking assignment for a variable must be like exactly once or something?
            counter <= counter + 1;
        end

        // assign the current sample if the oscillator is enabled, otherwise just output silence
        if (en) begin
            if (lfsr[0]) begin
                sample <= 16'd32767; // INT16_MAX
            end else begin 
                sample <= -16'd32768; // INT16_MIN
            end
        end else begin 
            sample <= 0;
        end
        // $display("[osc_noise] clock");
    end
endmodule