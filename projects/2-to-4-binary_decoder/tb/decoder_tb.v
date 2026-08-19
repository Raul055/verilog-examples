// Timescale
`timescale 1ns/1ps

// Module
module decoder_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    reg [1:0] a;
    reg en;
    wire [3:0] y;

    // Instantiate the DUT
    decoder_top uut (
        .a(a),
        .en(en),
        .y(y)
    );

    // Begin test
    initial begin
        // Disabled -> en=0
        en = 1'b0;
        a = 2'b00; #10;
        a = 2'b01; #10;
        a = 2'b10; #10;
        a = 2'b11; #10;

        // Enabled -> en=1
        en = 1'b1;
        a = 2'b00; #10;
        a = 2'b01; #10;
        a = 2'b10; #10;
        a = 2'b11; #10;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t en=%b a=%b y=%b", $time, en, a, y);
    end

    // Dumps .vcd file
    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_tb);
    end

endmodule
