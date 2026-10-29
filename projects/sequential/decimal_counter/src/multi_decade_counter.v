module multi_decade_counter
	(
		input clk,
		input reset,
		input enable,
		output done, // to cascade it even more
		output [3:0] ones, tens, hundreds, thousands
	);
	
	wire done0, done1, done2, done3;
	wire a0, a1, a2, a3;
	
	BCD_counter D0(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.done(done0),
		.Q(ones)
	);
	assign a0 = enable & done0;
	
	BCD_counter D1(
		.clk(clk),
		.reset(reset),
		.enable(a0),
		.done(done1),
		.Q(tens)
	);
	assign a1 = a0 & done1;
	
	BCD_counter D2(
		.clk(clk),
		.reset(reset),
		.enable(a1),
		.done(done2),
		.Q(hundreds)
	);
	assign a2 = a1 & done2;
	
	BCD_counter D3(
		.clk(clk),
		.reset(reset),
		.enable(a2),
		.done(done3),
		.Q(thousands)
	);
	assign a3 = a2 & done3;
	
	assign done = a3;

endmodule