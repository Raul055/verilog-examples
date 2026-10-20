module D_latch
    (
        input D,
        input clk,
        output reg Q,
        output Q_b
    );
    
    // D-Latch
    assign Q_b = ~Q;
    always @(D, clk)
    begin
        Q = Q;
        if (clk)
            Q = D;
        else
            Q = Q;
    end
    
endmodule