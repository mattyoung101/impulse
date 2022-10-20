// This file is part of Impulse, the retro music FPGA synthesizer.
// Copyright (c) 2022 Matt Young. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0
//
// Noise oscillator for Impulse
// This oscillator is based on a 16-bit maximal-period LFSR, sourced from:
// https://en.wikipedia.org/wiki/Linear-feedback_shift_register#Example_polynomials_for_maximal_LFSRs
// taps are 16, 15, 13, 4 or 0xD008 in hex
// The LFSR update code is based on an excellent article from ZipCPU:
// https://zipcpu.com/dsp/2017/10/27/lfsr.html

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
    // period: wait this many samples before updating the noise value 
    input logic[16:0] period
);
    // current counter between samples (via period)
    logic [16:0] counter = 0;
    // LFSR value
    logic [16:0] lfsr = 16'hACE1;

    always_ff @(posedge clk) begin
        if (rst) begin
            // reset logic
            counter <= 0;
            lfsr <= 16'hACE1;
        end else if (counter >= period) begin
            // period has elapsed, time to generate a sample
            // uses the Galois representation (see the ZipCPU article), the hex 0xD008 are the maximal period
            // 16-bit taps as listed above
            if (lfsr[0]) begin
                lfsr <= { 1'b0, lfsr[15:1] } ^ 16'hD008;
            end else begin
                lfsr <= { 1'b0, lfsr[15:1] };
            end

            counter <= 0;
        end else if (counter < period) begin
            // not reset and still counting up
            // counter update has to be here, otherwise it doesn't work as it should
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
    end
endmodule