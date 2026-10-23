module hex_segment_counter_top
    #(parameter FINAL_VALUE = 99_999_999)
    (
        input clk,
        input reset,
        input enable,
        input up, // when asserted the counter is up, else down counter
        output [3:0] an,
        output [7:0] seg
    );
    
    // 1s timer for 100MHz clk
    wire timer_done;
    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) one_second_timer (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .done(timer_done)
    );
    
    // up/down counter (4-bits)
    wire [3:0] Q;
    up_down_counter #(.N(4)) hex_counter (
        .clk(clk),
        .reset(reset),
        .enable(enable & timer_done),
        .up(up),
        .Q(Q)
    );
    
    // display driver
    wire enable_dp = 1'b1; // dp disabled
    assign an = 4'b1110; // last digit enable
    hex_to_7_seg segment_display (
        .hex(Q),
        .dp(enable_dp),
        ._7_seg(seg)
    );
    
endmodule