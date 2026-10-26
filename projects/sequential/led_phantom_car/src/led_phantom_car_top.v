module led_phantom_car_top
    #(
        parameter FINAL_VALUE=49_999_999, // 100 MHz clk
        parameter N_counter=4, // N-bits
        parameter N_led=16 // LEDs
    )
    (
        input clk,
        input reset,
        input enable,
        output [N_led-1:0] led
    );
    
    // half-second timer
    wire timer_done;
    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) half_second_timer (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .done(timer_done)
    );
    
    // Phantom car display effect
    wire [N_counter-1:0] decoder_in;
    up_down_counter #(.N(N_counter)) counter (
        .clk(clk),
        .reset(reset),
        .enable(enable & timer_done),
        .Q(decoder_in)
    );
    
    // LED outputs
    decoder #(.N_in(N_counter), .N_out(N_led)) led_decoder (
        .in(decoder_in),
        .out(led)
    );
    
endmodule