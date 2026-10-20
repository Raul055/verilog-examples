module storage_elements_top
    (
        input D,
        input clk,
        output Qa,
        output Qb,
        output Qc
    );
    
    D_latch L0 (
        .D(D),
        .clk(clk),
        .Q(Qa),
        .Q_b()
    );
    
    D_FF_neg FF0 (
        .D(D),
        .clk(clk),
        .Q(Qb)
    );
    
    D_FF_pos FF1 (
        .D(D),
        .clk(clk),
        .Q(Qc)
    );
    
endmodule