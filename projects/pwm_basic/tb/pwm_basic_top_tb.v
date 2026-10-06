// Timescale
`timescale 1ns/1ps

// Module
module pwm_basic_top_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    localparam T = 10;
    localparam resolution_bits = 8;
    reg clk;
    reg reset;
    reg [resolution_bits-1:0] duty_cycle;
    wire pwm_out;

    // Instantiate the DUT
    pwm_basic_top #(.resolution_bits(resolution_bits))
    uut (
        .clk(clk),
        .reset(reset),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );
    
    // Timer
    //initial
    //    #(7 * 2**resolution_bits * T) $stop;
    
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
        reset = 1;
        #2;
        reset = 0;
        duty_cycle = 0.25 * (2**resolution_bits);
        
        // duty_cycle = 50%
        repeat(2 * 2**resolution_bits) @(posedge clk);
        duty_cycle = 0.50 * (2**resolution_bits);
        
        // duty_cycle = 75%
        repeat(2 * 2**resolution_bits) @(posedge clk);
        duty_cycle = 0.75 * (2**resolution_bits);

        $finish;
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, pwm_basic_top_tb);
    end

endmodule