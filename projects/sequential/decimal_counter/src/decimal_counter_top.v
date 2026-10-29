module decimal_counter_top
    #(
        parameter FINAL_VALUE_1s=99_999_999, // 1s for 100MHz
        parameter FINAL_VALUE_1khz=99_999   // 1kHz for 100MHz
    )
    (
        input clk,
        input reset,
        input enable,
        output [7:0] seg,
        output [3:0] an
    );
    
    // 1s timer
    wire one_second_timer_done;
    timer_parameter #(.FINAL_VALUE(FINAL_VALUE_1s)) one_second_timer (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .done(one_second_timer_done)
    );
    
    // 1kHz timer for mux
    localparam ONE_KHZ_TIMER_ENABLE=1'b1; // always enabled
    wire one_khz_timer_done;
    timer_parameter #(.FINAL_VALUE(FINAL_VALUE_1khz)) one_khz_timer (
        .clk(clk),
        .reset(reset),
        .enable(ONE_KHZ_TIMER_ENABLE),
        .done(one_khz_timer_done)
    );
    
    // up-counter for anode selection
    localparam N_up_counter=2; // for 0-3
    wire [N_up_counter-1:0] anode_select;
    up_counter #(.N(N_up_counter)) anode_counter (
        .clk(clk),
        .reset(reset),
        .enable(one_khz_timer_done), // changes every 1kHz
        .Q(anode_select)
    );
    
    // multi-decade counter
    wire done;
    wire [3:0] ones, tens, hundreds, thousands;
    multi_decade_counter decade_counter (
        .clk(clk),
		.reset(reset),
		.enable(enable & one_second_timer_done), // every second
		.ones(ones),
		.tens(tens),
		.hundreds(hundreds),
		.thousands(thousands),
		.done(done)
    );
    
    // mux 4x1
    localparam N_bits=4;
    wire [3:0] digit;
    mux_4x1_nbit #(.N(N_bits)) anode_mux (
        .w0(ones),
        .w1(tens),
        .w2(hundreds),
        .w3(thousands),
        .s(anode_select),
        .f(digit)
    );
    
    // decoder for anode
    localparam anode_decoder_bits=2;
    localparam enable_decoder=1'b1; // always enable
    wire [3:0] an_out;
    decoder #(.N(anode_decoder_bits)) anode_decoder (
        .w(anode_select),
        .en(enable_decoder),
        .y(an_out)
    );
    assign an = ~an_out;
        
    // decimal to 7 segment display
    localparam ENABLE_DP=0;
    decimal_to_7_seg #(.enable_dp(ENABLE_DP)) decimal2sseg (
        .decimal(digit),
        ._7_seg(seg)
    );
    
endmodule