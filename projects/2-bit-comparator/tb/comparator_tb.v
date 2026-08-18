// Timescale
`timescale 1ns/1ps

// Module
module comparator_tb;
    // Declare signals to connect to DUT
    reg [1:0] a, b;
    wire aeqb;

    // Instantiate the UUT
    comparator_top uut (
        .a(a),
        .b(b),
        .aeqb(aeqb)
    );

    // Begin test
    initial begin
        // a=00 | b=00 -> should be equal
        a = 2'b00; b = 2'b00; #10;
        
        // a=01 | b=01 -> should be equal
        a = 2'b01; b = 2'b01; #10;
        
        // a=10 | b=11 -> should NOT be equal
        a = 2'b10; b = 2'b11; #10;
        
        // a=11 | b=11 -> should be equal
        a = 2'b11; b = 2'b11; #10;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t a=%b b=%b aeqb=%b", $time, a, b, aeqb);
    end

    // Dumps .vcd file
    initial begin
        $dumpfile("comparator.vcd");
        $dumpvars(0, comparator_tb);
    end

endmodule
