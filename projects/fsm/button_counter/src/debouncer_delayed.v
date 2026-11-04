module debouncer_delayed
	(
		input clk, reset,
		input noisy,
		output debounced
	);
	
	wire timer_done, timer_reset;
	
	debouncer_delayed_fsm FSM0(
		.clk(clk),
		.reset(reset),
		.noisy(noisy),
		.timer_done(timer_done),
		.timer_reset(timer_reset),
		.debounced(debounced)
	);
	
	// 20 ms timer for 100 MHz clock
	timer_parameter #(.FINAL_VALUE(1_999_999)) T0(
		.clk(clk),
		.reset(timer_reset),
		.enable(~timer_reset),
		.done(timer_done)
	);

endmodule