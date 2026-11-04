// Timescale
`timescale 1ns/1ps

// Module
module edge_detector_tb;
    localparam TIMEOUT=500_000;
    localparam T=10;
    reg clk;
    reg reset;
    reg level;
    wire p_edge;
    wire n_edge;
    wire _edge;

    // Instantiate the DUT
    edge_detector uut
        (
            .clk(clk),
            .reset(reset),
            .level(level),
            .p_edge(p_edge),
            .n_edge(n_edge),
            ._edge(_edge)
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
        reset = 1'b1;
        level = 1'b0;
        #12;
        reset = 1'b0;

        repeat(10)
        begin
            level = 1'b1;
            #20;
            level = 1'b0;
            #20;
        end
        
        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("|time=%t | reset=%b | level=%b | p_edge=%b | n_edge=%b | _edge=%b |",
                    $time, reset, level, p_edge, n_edge, _edge);
    end

   // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, edge_detector_tb);
    end

endmodule