// Timescale
`timescale 1ns/1ps

// Module
module storage_elements_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    reg clk;
    reg D;
    wire Q_latch;
    wire Q_ff_pos;
    wire Q_ff_neg;
    
    // Instantiate uut
    storage_elements_top uut(
        .D(D),
        .clk(clk),
        .Qa(Q_latch),
        .Qb(Q_ff_pos),
        .Qc(Q_ff_neg)
    );
    
    // Generate stimuli
    localparam T = 20; // clk period
    always
    begin
        clk = 1'b0;
        #(T/2);
        clk = 1'b1;
        #(T/2);
    end

    // Begin test
    initial begin
        D = 1'b1;
        #(2 * T);
        D = 1'b0;
        
        @(posedge clk);
        D = 1'b1;
        
        #2 D = 1'b0;
        #3 D = 1'b1;
        #4 D = 1'b0;
        
        repeat(2) @(negedge clk);
        D = 1'b1;
        
        #20;

        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t D=%b Q_latch=%b Q_ff_pos=%b Q_ff_neg", $time,
                    D, Q_latch, Q_ff_pos, Q_ff_neg);
    end


    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, storage_elements_tb);
    end

endmodule