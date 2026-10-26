// Timescale
`timescale 1ns/1ps

// Module
module timer_parameter_tb;
	localparam FINAL_VALUE = 20;
	reg clk;
	reg reset;
	reg enable;
	wire done;
	
	// Instantiate uut
	timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) uut(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.done(done)
	);
	
	// Generate clk signal
	localparam T = 10; // clk period
	always
	begin
		clk = 1'b0;
		#(T/2);
		clk = 1'b1;
		#(T/2);
	end
	
	// Begin test
	initial begin
		reset = 1'b1;
		#2
		reset = 1'b0;
		#2
		enable = 1'b1;
		
		repeat(50) @(negedge clk);
		
		reset = 1'b1;
		repeat(50) @(negedge clk);
		
		$finish;
	end
	
	// Prints results to console
	initial begin
		$monitor("time=%0t reset=%b done=%b", $time,
		reset, done);
	end
	
	// Dumps .vcd file
	initial begin
		`ifdef VCD_PATH
		$dumpfile(`VCD_PATH);
		`else
		$dumpfile("default.vcd");
		`endif
		$dumpvars(0, timer_parameter_tb);
	end

endmodule