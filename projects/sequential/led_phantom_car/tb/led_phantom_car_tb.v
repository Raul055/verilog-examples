// Timescale
`timescale 1ns/1ps

// Module
module led_phantom_car_tb;
	localparam FINAL_VALUE = 5;
	localparam N_counter = 4;
	localparam N_led = 16;
	reg clk;
	reg reset;
	reg enable;
	wire [N_led-1:0] led;
	
	// Instantiate uut
	led_phantom_car_top 
	#(
       .FINAL_VALUE(FINAL_VALUE),
       .N_counter(N_counter),
       .N_led(N_led)
	 ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .led(led)
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
		
		repeat(100) @(posedge clk);
		
		$finish;
	end
	
	// Prints results to console
	initial begin
		$monitor("time=%0t reset=%b enable=%b led=%b", $time,
		reset, enable, led);
	end
	
	// Dumps .vcd file
	initial begin
		`ifdef VCD_PATH
		$dumpfile(`VCD_PATH);
		`else
		$dumpfile("default.vcd");
		`endif
		$dumpvars(0, led_phantom_car_tb);
	end

endmodule