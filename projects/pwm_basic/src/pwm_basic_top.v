module pwm_basic_top
    #(parameter resolution_bits=8)
    (
        input clk,
        input reset,
        input [resolution_bits-1:0] duty_cycle,
        output pwm_out
    );
    
    // Up counter
    reg [resolution_bits-1:0] Q_reg;
    reg [resolution_bits-1:0] Q_next;
    
    // Reset
    always@(posedge clk, posedge reset)
    begin
        if (reset)
            Q_reg <= 0;
        else
            // Refresh every clk
            Q_reg <= Q_next;
    end
    
    // Next state logic
    always@(*)
    begin
        // Counts up
        Q_next = Q_reg + 1;
    end
    
    // Output logic
    assign pwm_out = (Q_reg < duty_cycle);
    
endmodule