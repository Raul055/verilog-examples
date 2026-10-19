module decimal_counter_top
    #(parameter integer MAX_CLK_COUNT = 50_000_000)
    (
        input wire clk, // 100MHz clk
        input wire reset, // reset
        output wire [3:0] an,
        output wire [7:0] seg
    );
    
    // Register for counting clock cycles
    localparam integer COUNTER_WIDTH = $clog2(MAX_CLK_COUNT);
    reg [COUNTER_WIDTH-1:0] clk_counter = 0;
    
    // Maximum count for counter
    localparam MAX_COUNTER_VALUE = 9999;
    
    // Counter of 14-bits
    reg [13:0] counter = 0;
    
    // Counts every second
    always@(posedge clk, posedge reset)
    begin
        // Reset button
        if (reset)
            begin
                clk_counter <= 0; // reset clk counter
                counter <= 0; // reset counter
            end
        
        // Every second
        else if (clk_counter == MAX_CLK_COUNT - 1)
            begin
                clk_counter <= 0; // reset counter
                 
                 // Reset counter value when achieved max real value
                 if (counter > MAX_COUNTER_VALUE)
                    counter <= 0;
                 // Counter goes up
                 else
                    counter <= counter + 1;
            end
        
        // Continue clk
        else
            clk_counter <= clk_counter + 1;
    end
  
    // Digit values registers
    wire [3:0] thousands;
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;
    
    // Gets digits from counter value
    bin_to_bcd bcd_converter (
        .bin(counter),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );
  
    // Display value
    display_number display_digit(
        .clk(clk),
        .thousands_value(thousands),
        .hundreds_value(hundreds),
        .tens_value(tens),
        .ones_value(ones),
        .an(an),
        .seg(seg)
    );
  
endmodule