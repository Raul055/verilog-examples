module display_number
    #(parameter refresh_bits=17)
    (
        // For multiplexing
        input wire clk,
        // All digits from display
        input wire [3:0] thousands_value,
        input wire [3:0] hundreds_value,
        input wire [3:0] tens_value,
        input wire [3:0] ones_value,
        // Seven segments
        output reg [3:0] an,   // 4 digit display
        output wire [7:0] seg   // 7 segments
    );
    
    // Iterates between all digits for select
    reg [refresh_bits-1:0] refresh = 0;
    always @(posedge clk)
        refresh <= refresh + 1;
    wire [1:0] select = refresh[refresh_bits-1:refresh_bits-2];
    
    // Select value for digit
    reg [3:0] digit_val;
    always @(*)
    begin
        // Asuming left to right
        case(select)
            2'd0:
                begin
                    an = 4'b1110;
                    digit_val = ones_value;
                end
            2'd1:
                begin
                    an = 4'b1101;
                    digit_val = tens_value;
                end
            2'd2:
                begin
                    an = 4'b1011;
                    digit_val = hundreds_value;
                end
            2'd3:
                begin
                    an = 4'b0111;
                    digit_val = thousands_value;
                end
        endcase
    end
    
    // Writes output for 7 segment
    decimal_to_7_seg seven_seg(
        .decimal(digit_val),
        ._7_seg(seg)
    );
    
endmodule