module button
	(
		input clk,
		input reset,
		input noisy,
		output debounced,
		output p_edge,
		output n_edge,
		output _edge
	);
	
	// For clean button
	debouncer_delayed DD0(
		.clk(clk),
		.reset(reset),
		.noisy(noisy),
		.debounced(debounced)
	);
	
	// For edge detection from clean button
	edge_detector ED0(
		.clk(clk),
		.reset(reset),
		.level(debounced),
		.p_edge(p_edge),
		.n_edge(n_edge),
		._edge(_edge)
	);

endmodule