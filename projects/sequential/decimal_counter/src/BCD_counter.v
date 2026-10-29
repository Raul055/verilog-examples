module BCD_counter
	(
		input clk,
		input reset,
		input enable,
		output done,
		output [3:0] Q
	);
	
	reg [3:0] Q_reg, Q_next;
	
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
	assign done = Q_reg == 9;
	
	always @(*)
		Q_next = done? 'b0: Q_reg + 1;
	
	// Ouput logic
	assign Q = Q_reg;
	
endmodule