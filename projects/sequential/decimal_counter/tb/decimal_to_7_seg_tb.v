// Timescale
`timescale 1ns/1ps

// Module
module decimal_to_7_seg_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    parameter ENABLE_DP = 0;
    reg [3:0] decimal;
    wire [7:0] _7_seg;

    // Instantiate the DUT
    decimal_to_7_seg #(.enable_dp(ENABLE_DP))
    uut (
        .decimal(decimal),
        ._7_seg(_7_seg)
    );

    // Begin test
    initial begin
        
        decimal=4'd0; #10;
        decimal=4'd1; #10;
        decimal=4'd2; #10;
        decimal=4'd3; #10;
        decimal=4'd4; #10;
        decimal=4'd5; #10;
        decimal=4'd6; #10;
        decimal=4'd7; #10;
        decimal=4'd8; #10;
        decimal=4'd9; #10;

        // Shall have default value here 
        decimal=4'd10; #10;
        decimal=4'd11; #10;
        decimal=4'd12; #10;
        decimal=4'd13; #10;
        decimal=4'd14; #10;
        decimal=4'd15; #10;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t\n--- decimal=(%b | %d) --- display=(%b)",
                  $time, decimal, decimal, _7_seg);
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, decimal_to_7_seg_tb);
    end

endmodule
