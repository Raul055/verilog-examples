// Timescale
`timescale 1ns/1ps

// Module
module hex_sequence_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    localparam integer T=10;
    reg clk;
    reg reset;
    wire [3:0] an;
    wire [7:0] seg;

    // Function to translate the number from segments
    function [3:0] segment_to_number;
        input [7:0] segment;
        begin
            case(segment[6:0])
                7'b1000000: segment_to_number = 4'h0;
                7'b1111001: segment_to_number = 4'h1;
                7'b0100100: segment_to_number = 4'h2;
                7'b0110000: segment_to_number = 4'h3;
                7'b0011001: segment_to_number = 4'h4;
                7'b0010010: segment_to_number = 4'h5;
                7'b0000010: segment_to_number = 4'h6;
                7'b1111000: segment_to_number = 4'h7;
                7'b0000000: segment_to_number = 4'h8;
                7'b0010000: segment_to_number = 4'h9;
                7'b0001000: segment_to_number = 4'ha;
                7'b0000011: segment_to_number = 4'hb;
                7'b1000110: segment_to_number = 4'hc;
                7'b0100001: segment_to_number = 4'hd;
                7'b0000110: segment_to_number = 4'he;
                7'b0001110: segment_to_number = 4'hf;
                default: segment_to_number = 4'h0;
            endcase
        end
    endfunction

    // Instantiate the DUT
    hex_segment_counter_top #(.MAX_COUNT(T)) 
    uut (
        .clk(clk),
        .reset(reset),
        .an(an),
        .seg(seg)
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

    // Previous segment to see change in register
    reg [7:0] seg_prev;

    // Begin test
    initial begin

        // Takes initial value
        seg_prev = seg;

        // Run for enough cycles to see several values
        repeat (40 * T * 2)
        begin
            @(posedge clk);
            
            // Observe change in number
            if(seg !== seg_prev)
            begin
                $display("Time %0t: an: %b, seg: %b (%h)", $time, an, seg, segment_to_number(seg));
                seg_prev = seg; // Updates previous segment
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
        $dumpvars(0, hex_sequence_tb);
    end

endmodule
