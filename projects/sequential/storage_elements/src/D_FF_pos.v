module D_FF_pos
    (
        input D,
        input clk,
        output reg Q
    );
    
    // D Flip-Flop with posedge
    always @(posedge clk)
    begin
        Q = D;
    end
    
endmodule
