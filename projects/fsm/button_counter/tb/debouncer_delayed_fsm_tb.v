// Timescale
`timescale 1ns/1ps

// Module
module debouncer_delayed_fsm_tb;
    localparam TIMEOUT=500_000;
    localparam T=10;
    localparam N=4;
    reg clk;
    reg reset;
    reg noisy;
    reg timer_done;
    wire timer_reset;
    wire debounced;

    // Instantiate the DUT
    debouncer_delayed_fsm uut
        (
            .clk(clk),
            .reset(reset),
            .noisy(noisy),
            .timer_done(timer_done),
            .timer_reset(timer_reset),
            .debounced(debounced)
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
        noisy = 1'b0;
        timer_done = 1'b0;
        #12;
        reset = 1'b0; 

        // nosiy input
        repeat(10)
        begin
            timer_done = 1'b0;
            noisy = 1'b1; #2;
            noisy = 1'b0; #3;
            noisy = 1'b1; #1;
            noisy = 1'b0; #1;
            noisy = 1'b1;
            timer_done = 1'b1; #2;
            
            #20;
            
            timer_done = 1'b0;
            noisy = 1'b0; #1;
            noisy = 1'b1; #4;
            noisy = 1'b0; #2;
            timer_done = 1'b1; #2;
            
            #20;
        end
        
        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("| time=%t | reset=%b | noisy=%b | timer_done=%b | timer_reset=%b | debounced=%b |",
                    $time, reset, noisy, timer_done, timer_reset, debounced);
    end

   // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, debouncer_delayed_fsm_tb);
    end

endmodule