// This file is part of Impulse, the retro music FPGA synthesizer.
// Copyright (c) 2022 Matt Young. All rights reserved.

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0

// Square wave oscillator for Impulse, with configurable pulse width

module osc_noise(
    // AUDIO PARAMS
    // INPUTS
    // clock line to generate samples
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

    // OSCILLATOR PARAMS
    // note frequency, corresponds to MIDI 0 ~= 8 Hz, up to at least MIDI 127 ~= 13289 Hz (+ extra, 2^14 = 16384 Hz)
    input logic [14:0] frequency,
    // pulse width of the square wave, between 0 and 16384 samples
    input logic [14:0] pulseWidth
);
    // TODO
endmodule