// Timescale
`timescale 1ns/1ps

// Module
module hex_segment_counter_tb;
	localparam FINAL_VALUE = 5;
	reg clk;
	reg reset;
	reg enable;
	reg up;
	wire [3:0] an;
	wire [7:0] seg;
	
	// Instantiate uut
	hex_segment_counter_top #(.FINAL_VALUE(FINAL_VALUE)) uut(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.up(up),
		.an(an),
		.seg(seg)
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
		// Apply reset first
        reset  = 1'b1;
        enable = 1'b1;
        up     = 1'b1;
        repeat(3) @(posedge clk);
        #1 reset = 1'b0;

        wait(seg == 8'b1000_1110);   // F (dp = 1)
        $display("Reached F at %0t", $time);

        up = 1'b0;
        wait(seg == 8'b1001_0010);   // 5 (dp = 1)
        $display("Reached 5 at %0t", $time);

        reset = 1'b1;
        repeat(10) @(posedge clk);
        $finish;
	end
	
	// Prints results to console
	initial begin
		$monitor("time=%0t reset=%b enable=%b up=%b seg=%b", $time,
		reset, enable, up, seg);
	end
	
	// Dumps .vcd file
	initial begin
		`ifdef VCD_PATH
		$dumpfile(`VCD_PATH);
		`else
		$dumpfile("default.vcd");
		`endif
		$dumpvars(0, hex_segment_counter_tb);
	end

endmodule