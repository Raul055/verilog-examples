// Timescale
`timescale 1ns/1ps

// Module
module hex_to_7_seg_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    reg [4:0] sw;
    wire [3:0] an;
    wire [7:0] seg;

    // Instantiate the DUT
    hex_to_7_seg_top uut (
        .sw(sw),
        .an(an),
        .seg(seg)
    );

    // Begin test
    initial begin
        // Segments inputs (0 to 16)
        sw = 4'b0000; #10;
        sw = 4'b0001; #10;
        sw = 4'b0010; #10;
        sw = 4'b0011; #10;
        sw = 4'b0100; #10;
        sw = 4'b0101; #10;
        sw = 4'b0110; #10;
        sw = 4'b0111; #10;
        sw = 4'b1000; #10;
        sw = 4'b1001; #10;
        sw = 4'b1010; #10;
        sw = 4'b1011; #10;
        sw = 4'b1100; #10;
        sw = 4'b1101; #10;
        sw = 4'b1110; #10;
        sw = 4'b1111; #10;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t an=%b sw=%b seg=%b", $time, an, sw, seg);
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, hex_to_7_seg_tb);
    end

endmodule
