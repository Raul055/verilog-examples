// Timescale
`timescale 1ns/1ps

// Module
module decoder_tb;
    // N-bits
    localparam N_in=4;
    localparam N_out=16;
    // I/O
    reg [N_in-1:0] in;
    wire [N_out-1:0] out;

    // Instantiate the DUT
    decoder #(.N_in(N_in), .N_out(N_out)) uut (
        .in(in),
        .out(out)
    );

    // Begin test
    initial begin
        in = 'd0; #10;
        in = 'd1; #10;
        in = 'd2; #10;
        in = 'd3; #10;
        in = 'd4; #10;
        in = 'd5; #10;
        in = 'd6; #10;
        in = 'd7; #10;
        in = 'd8; #10;
        in = 'd9; #10;
        in = 'd10; #10;
        in = 'd11; #10;
        in = 'd12; #10;
        in = 'd13; #10;
        in = 'd14; #10;
        in = 'd15; #10;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t in=%b out=%b", $time, in, out);
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, decoder_tb);
    end

endmodule