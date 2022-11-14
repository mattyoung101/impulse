// This file is part of Impulse, the retro music FPGA synthesizer.
// Copyright (c) 2022 Matt Young. All rights reserved.

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0

// Noise oscillator for Impulse
// This oscillator is based on a 16-bit maximal-period LFSR, sourced from:
// https://en.wikipedia.org/wiki/Linear-feedback_shift_register#Example_polynomials_for_maximal_LFSRs
// taps are 16, 15, 13, 4 or 0xD008 in hex
// The LFSR update code is based on an excellent article from ZipCPU:
// https://zipcpu.com/dsp/2017/10/27/lfsr.html
`timescale 1ns/1ns
module osc_noise(
    // AUDIO PARAMS
    // INPUTS
    // clock line to generate noise samples
    input logic clk,
    // true if we should reset
    input logic rst,
    // true if oscillator is enabled
    input logic en,
    // volume between -32768 and 32767
    input logic signed[16:0] volume,
    // OUTPUTS
    // 16-bit signed audio sample
    output logic signed[16:0] sample,

    // OSCILLATOR INPUT PARAMS
    // MIDI note number (0-127)
    input logic [7:0] note
);
    // current counter between samples (via period)
    logic [16:0] counter = 0;
    // LFSR value
    logic [16:0] lfsr = 16'hACE1;
    // period counter, based on note
    logic [16:0] period = 0;

    always_ff @(posedge clk) begin
        // TODO we really need to make sure this runs _before_ the below block!
        // I think we can really only test it in hardware or maybe in CXXRTL.
        //
        // period is based off MIDI note frequency!
        // basically the lower notes you play, the more crushed it is, and the higher notes you play, the more
        // like white noise it is
        period <= note_to_period(note);

        if (rst) begin
            // reset logic
            counter <= 0;
            period <= 0;
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
    end

    // assign the current sample if the oscillator is enabled, otherwise just output silence
    always_comb begin
        if (en) begin
            if (lfsr[0]) begin
                sample = volume;
            end else begin 
                sample = -volume;
            end
        end else begin 
            sample = 0;
        end
    end
endmodule