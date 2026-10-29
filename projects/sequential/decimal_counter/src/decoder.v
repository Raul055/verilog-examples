module decoder
	#(parameter N=4) // n inputs
	(
		input [N-1:0] w,
		input en,
		output reg [2**N-1:0] y // 2^N outputs
	);
	
	always @(w, en)
	begin
		y = 'b0; // default
		if (en)
			y[w] = 1'b1;
		else
			y = 'b0;
	end
	
endmodule