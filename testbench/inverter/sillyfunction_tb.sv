module testbench1();
    // logic a, b, c, y;
    
    // // instantiate device under test
    // sillyfunction dut(a, b, c, y);
    
    // // apply inputs one at a time
    // initial begin
    //     $dumpfile("test.vcd");
    //     $dumpvars(a,b,c,y);

    //     a = 0; b = 0; c = 0; #10;
    //     c = 1;
    //     #10;
    //     b = 1; c = 0;
    //     #10;
    //     c = 1;
    //     #10;
    //     a = 1; b = 0; c = 0; #10;
    //     c = 1;
    //     #10;
    //     b = 1; c = 0;
    //     #10;
    //     c = 1;
    //     #10;
    // end

    logic [8:0] x, y;

    inverter mrInverter(x, y);

    initial begin
        $display("Hello world!");
        $dumpfile("test2.vcd");
        $dumpvars(x,y);

        x = 8'b00001111;
        #10;
        x = 8'b11110000;
        #10;
    end
endmodule
