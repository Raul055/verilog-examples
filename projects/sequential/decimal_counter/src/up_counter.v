module up_counter
	#(parameter N=4)
	(
		input clk,
		input reset,
		input enable,
		output [N-1:0] Q
	);
	
	// Register
	reg [N-1:0] Q_reg, Q_next;
	always @(posedge clk, posedge reset)
	begin
		if(reset)
			Q_reg <= 0;
		else if(enable)
			Q_reg <= Q_next;
		else
			Q_reg <= Q_reg;
	end
	
	// Next state logic
	always @(Q_reg)
	begin
		Q_next = Q_reg + 1;
	end
	
	// Ouput logic
	assign Q = Q_reg;
	
endmodule
