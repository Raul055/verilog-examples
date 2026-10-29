// Timescale
`timescale 1ns/1ps

// Module
module decimal_counter_tb;
    localparam TIMEOUT=500_000;
    localparam T=10;
    localparam FINAL_VALUE_1s=999;
    localparam FINAL_VALUE_1khz=9;
    reg clk;
    reg reset;
    reg enable;
    wire [7:0] seg;
    wire [3:0] an;

    // Instantiate the DUT
    decimal_counter_top 
        #(
            .FINAL_VALUE_1s(FINAL_VALUE_1s),
            .FINAL_VALUE_1khz(FINAL_VALUE_1khz)
        )
    uut
        (
            .clk(clk),
            .reset(reset),
            .enable(enable),
            .seg(seg),
            .an(an)
        );

    // Timeout
    initial begin
        #(TIMEOUT);
        $display("Timeout at %t", $time);
        $finish;
    end

    // Clock signal
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end

    // Begin test
    initial begin
        // Reset for intial duty_cycle = 25%
        reset = 1'b1;
        enable = 1'b1;
        #12;
        reset = 1'b0;

        // 10 in display
        wait((an == 4'b1101) && (seg == 8'b11111001));
        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("|time=%t | reset=%b | enable=%b | an=%b | seg=%b |",
                    $time, reset, enable, an, seg);
    end

   // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, decimal_counter_tb);
    end

endmodule