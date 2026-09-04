module led_blink_top
    #(parameter integer MAX_COUNT = 50_000_000)
    (
        input wire clk, // Basys 3 has 100MHz
        output reg led  // led register
    );
    
    // Register for counting clock cycles
    localparam integer COUNTER_WIDTH = $clog2(MAX_COUNT);
    reg [COUNTER_WIDTH-1:0] counter = 0;
    
    // Initially, led is LOW
    initial led = 0;
    
    always@(posedge clk)
    begin
        if (counter == MAX_COUNT - 1)
        begin
            counter <= 0; // reset counter
            led <= ~led;  // toggle led
        end
        else
            counter <= counter + 1;
    end
    
endmodule
