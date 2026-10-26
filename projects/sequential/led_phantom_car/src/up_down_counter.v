module up_down_counter
	#(parameter N=4)
	(
		input clk,
		input reset,
		input enable,
		output [N-1:0] Q
	);
	
	// Register
	reg down_flag, down_flag_next;
	reg [N-1:0] Q_reg, Q_next;
	always @(posedge clk, posedge reset)
	begin
		// Asynchronous reset
		if(reset)
		begin
			Q_reg <= 0;
			down_flag <= 0;
		end
		// Enable counter
		else if(enable)
		begin
		    Q_reg <= Q_next;
		    down_flag <= down_flag_next;
		end
		// Counter disabled, maintain current value
		else
		begin	
			Q_reg <= Q_reg;
			down_flag <= down_flag;
		end
	end
	
	// Next state logic
	always @(Q_reg, Q_next, down_flag)
	begin
		// register
		Q_next = Q_reg;
		down_flag_next = down_flag;
		
		// Change register depending on flag
		if (down_flag)
			Q_next = Q_reg - 1;
		else
			Q_next = Q_reg + 1;
		
		// Change down flag
		if (Q_next == ((2**N) - 1)) // reaches max val, goes down
		    down_flag_next = 1'b1;
        else if (Q_next == 0) // reaches zero, goes up
            down_flag_next = 1'b0;
        else
            down_flag_next = down_flag; // no change
    end
	
	// Ouput logic
	assign Q = Q_reg;
	
endmodule