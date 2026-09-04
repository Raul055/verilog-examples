// Timescale
`timescale 1ns/1ps

// Module
module led_blink_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    localparam integer T=10;
    reg clk;
    wire led;

    // Instantiate the DUT
    led_blink_top #(.MAX_COUNT(T)) 
    uut (
        .clk(clk),
        .led(led)
    );

    // Clock
	// 10 ns clock running forever
	always
	begin
		clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
	end

    integer toggle_count = 0;  // Toggle counter
    reg     led_prev;  // Previous state of LED

    // Begin test
    initial begin
        led_prev = led;

        // Run for enough cycles to see several toggles
        repeat (10 * T * 2)
        begin
            @(posedge clk);
            if (led !== led_prev)
            begin
                toggle_count = toggle_count + 1;
                $display("Time %0t: led toggled to %b (toggle #%0d)", $time, led, toggle_count);
                led_prev = led;
            end
        end

        // Print in console if test passed
        if (toggle_count > 0)
            $display("TEST PASSED: led toggled %0d times", toggle_count);
        else
            $display("TEST FAILED: led never toggled");
        $finish;
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, led_blink_tb);
    end

endmodule
