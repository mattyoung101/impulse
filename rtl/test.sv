// Testing SystemVerilog

module TestModule (
    input logic[3:0] dataIn,
    output logic[3:0] dataOut
);
    assign dataOut = ~dataIn;
endmodule