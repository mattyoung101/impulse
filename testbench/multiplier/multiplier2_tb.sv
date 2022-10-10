`timescale 1ns/1ps

module multiplier2_tb();
    logic [8:0] a, b;
    logic [17:0] y;

    multiplier mult(a,b,y);

    initial begin
        $write("hello!!!");
        $dumpfile("multiplier2.vcd");
        $dumpvars;

        a = 8'd2;
        b = 8'd2;
        #10;
        $display("a = %d, b = %d, y = %d\n", a, b, y);

        a = 8'd4;
        b = 8'd4;
        #10;
        $display("a = %d, b = %d, y = %d\n", a, b, y);
        $write("done");
    end
endmodule

// TODO get a build task to work with icarus and waf/scons the build tool we use
// TODO maybe it is just easie to use make lol