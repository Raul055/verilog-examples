module button_counter_top
    #(parameter N=4)
    (
        input clk,
        input reset,
        input button_in,
        output [7:0] seg,
        output [3:0] an
    );
    
    // For debouncing
    wire debounced_tick;
    wire [N-1:0] Q_debounced;
    
    // Debounced button
    button DEBOUNCED_BUTTON (
        .clk(clk),
        .reset(reset),
        .noisy(button_in),
        .debounced(),
        .p_edge(debounced_tick),
        .n_edge(),
        ._edge()
    );
    
    // Counts button presses
    up_counter #(.N(N)) DEBOUNCED_BUTTON_COUNTER (
        .clk(clk),
        .reset(reset),
        .enable(debounced_tick),
        .Q(Q_debounced)
    );
    
    // Q to segment number
    hex_to_7_seg HEX2SSEG (
        .hex(Q_debounced),
        ._7_seg(seg)
    );
    
    // Only last digit enabled (CA)
    assign an = 4'b1110;
    
endmodule
