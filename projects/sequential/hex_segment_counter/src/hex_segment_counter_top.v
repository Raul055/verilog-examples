module hex_segment_counter_top
    #(parameter integer MAX_COUNT = 100_000_000)
    (
        input wire clk,             // Basys 3 has 100MHz
        input wire reset,           // Reset
        output wire [3:0] an,       // Anode for display
        output wire [7:0] seg       // 7 segment display
    );
    
    /* ========== CLOCK ==========*/
    
    // Register for counting clock cycles
    localparam integer COUNTER_WIDTH = $clog2(MAX_COUNT);
    reg [COUNTER_WIDTH-1:0] counter = 0;
    reg [3:0] hex_number;
    reg up_flag;
    
    // Initially, hex number is zero
    initial hex_number = 0;
    initial up_flag = 1; // first goes upwards
    
    // Hex value goes up and down
    always@(posedge clk, posedge reset)
    begin
        // Reset
        if (reset)
        begin
            hex_number <= 0;
            up_flag <= 1;
        end
        // Every second
        else if (counter == MAX_COUNT - 1)
        begin
            counter <= 0; // reset counter
            
            // Counters goes up
            if (up_flag)
                begin
                    if (hex_number >= 4'hF) // Gets to 15
                        up_flag <= 0;
                    else
                        hex_number <= hex_number + 1;
                end
            // Counter goes down
            else
                begin
                    if (hex_number <= 0) // Gets to 0
                        up_flag <= 1;
                    else
                        hex_number <= hex_number - 1;
                end
        end
        else
            counter <= counter + 1;
    end
        
    /* ========== Dispĺay ==========*/
    
    /* Signal declaration */
    wire dp_enable;           // Bit to enable decimal pont
    wire [3:0] hex_bits;      // Hex bits
    
    /* Assign */
    assign an = 4'b1110;        // Enable the last digit of the display (EN: LOW)
    assign dp_enable = 1;       // Decimal point disabled
    assign hex_bits = hex_number;
    
    hex_to_7_seg display_driver (
        .hex (hex_bits),
        .dp (dp_enable),
        ._7_seg (seg)
    );
    
endmodule
