// Timescale
`timescale 1ns/1ps

// Module
module up_down_counter_tb;
	localparam N = 4;
	reg clk;
	reg reset;
	reg enable;
	wire [N-1:0] Q;
	
	// Instantiate uut
	up_down_counter #(.N(N)) uut(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.Q(Q)
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
		enable = 1'b1;
		#2
		reset = 1'b0;
		
		wait(Q == 15);
		repeat(20) @(posedge clk);
		
		$finish;
	end
	
	// Prints results to console
	initial begin
		$monitor("time=%0t reset=%b enable=%b Q=%d", $time,
		reset, enable, Q);
	end
	
	// Dumps .vcd file
	initial begin
		`ifdef VCD_PATH
		$dumpfile(`VCD_PATH);
		`else
		$dumpfile("default.vcd");
		`endif
		$dumpvars(0, up_down_counter_tb);
	end

endmodule