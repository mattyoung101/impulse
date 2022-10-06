// module sillyfunction(input logic a, b, c,
//                      output logic y);
//     assign y = ~a & ~b & ~c | a & ~b & ~c | a & ~b & c;
// endmodule
module inverter(
    input logic [8:0] x,
    output logic [8:0] y
);
    assign y = ~x;
endmodule