// Timescale
`timescale 1ns/1ps

// Module
module display_number_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    localparam integer T=10;
    reg clk;
    reg [3:0] thousands_value = 0;
    reg [3:0] hundreds_value = 0;
    reg [3:0] tens_value = 0;
    reg [3:0] ones_value = 0;
    wire [3:0] an;
    wire [7:0] seg;

    // Instantiate the DUT
    display_number uut (
        .clk(clk),
        .thousands_value(thousands_value),
        .hundreds_value(hundreds_value),
        .tens_value(tens_value),
        .ones_value(ones_value),
        .an(an),
        .seg(seg)
    );

    // Clock
	always
	begin
		clk = 1'b1;
		#(T/2);
		clk = 1'b0;
		#(T/2);
	end

    // Begin test
    initial begin
        repeat (10)
        begin
            @(posedge clk);
            begin
                thousands_value <= thousands_value + 1;
                hundreds_value <= hundreds_value + 1;
                tens_value <= tens_value + 1;
                ones_value <= ones_value + 1;
                $display("Time:(%0t) -- an:(%b)\n--seg:(%b)--thousand=(%d)--hundreds=(%d)--tens=(%d)--ones=(%d)", 
                        $time, an, seg, thousands_value, hundreds_value, tens_value, ones_value);
            end
        end

        $finish;
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, display_number_tb);
    end

endmodule