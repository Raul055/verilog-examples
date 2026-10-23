module up_down_counter
	#(parameter N=4)
	(
		input clk,
		input reset,
		input enable,
		input up, // when asserted the counter is up, else down counter
		output [N-1:0] Q
	);
	
	// Register
	reg [N-1:0] Q_reg, Q_next;
	always @(posedge clk, posedge reset)
	begin
		// Asynchronous reset
		if(reset)
			Q_reg <= 0;
		// Enable UP/DOWN counter
		else if(enable)
			Q_reg <= Q_next;
		// Counter disabled, maintain current value
		else
			Q_reg <= Q_reg;
	end
	
	// Next state logic
	always @(Q_reg, up)
	begin
		Q_next = Q_reg;
		if (up)
			Q_next = Q_reg + 1;
		else
			Q_next = Q_reg - 1;
	end
	
	// Ouput logic
	assign Q = Q_reg;
	
endmodule