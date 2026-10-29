// Timescale
`timescale 1ns/1ps

// Module
module multi_decade_counter_tb;
    localparam TIMEOUT=500_000;
	reg clk;
	reg reset;
	reg enable;
	wire done;
	wire [3:0] ones;
	wire [3:0] tens;
	wire [3:0] hundreds;
    wire [3:0] thousands;
	
	// Instantiate uut
	multi_decade_counter uut(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.done(done),
		.ones(ones),
		.tens(tens),
		.hundreds(hundreds),
        .thousands(thousands)
	);

    // Timeout
    initial begin
        #(TIMEOUT);
        $display("Timeout at %t", $time);
        $finish;
    end
	
	// Generate clk signal
	localparam T = 5; // clk period
	always
	begin
		clk = 1'b0;
		#(T/2);
		clk = 1'b1;
		#(T/2);
	end
	
	// Begin test
	initial begin
		// Issue a quick reset for 2 ns
		reset = 1'b1;
		#10
		reset = 1'b0;
		#10
		enable = 1'b1;
		
        // final value
		wait((thousands == 9) && (hundreds == 9) && (tens == 9) && (ones == 9));
		
		$finish;
	end
	
	// Prints results to console
	initial begin
		$monitor("| time=%0t | reset=%b | thousands=%d | hundreds=%d | tens=%d | ones=%d |",
        $time, reset, thousands, hundreds, tens, ones);
	end
	
	// Dumps .vcd file
	initial begin
		`ifdef VCD_PATH
		$dumpfile(`VCD_PATH);
		`else
		$dumpfile("default.vcd");
		`endif
		$dumpvars(0, multi_decade_counter_tb);
	end

endmodule