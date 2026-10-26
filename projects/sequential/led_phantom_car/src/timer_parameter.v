module timer_parameter
	#(parameter FINAL_VALUE=255)
	(
		input clk,
		input reset,
		input enable,
		output done
	);
	
	localparam N = $clog2(FINAL_VALUE);
	reg [N-1:0] Q_reg, Q_next;
	
	// Register
	always @(posedge clk, posedge reset)
	begin
		// Asynchronous reset
		if(reset)
			Q_reg <= 0;
		// Enable counter
		else if(enable)
			Q_reg <= Q_next;
		// Counter disabled, maintain current value
		else
			Q_reg <= Q_reg;
	end
	
	// Next state logic
	assign done = Q_reg == FINAL_VALUE;
	
	always @(*)
		Q_next = done? 'b0: Q_reg + 1;
	
endmodule