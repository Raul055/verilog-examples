module D_FF_neg
    (
        input D,
        input clk,
        output reg Q
    );
    
    // D Flip-Flop with negedge
    always @(negedge clk)
    begin
        Q = D;
    end
    
endmodule