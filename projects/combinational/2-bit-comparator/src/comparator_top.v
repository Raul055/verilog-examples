module comparator_top
    (
        // I/O declaration
        input wire [1:0] a, b,
        output wire aeqb
    );
    
    // Internal signal declaration
    wire e0, e1;
    
    /* Body */
    
    // Instantiate two 1-bit comparators
    // Bit 0
    eq1 eq_bit0_unit(
        .i0(a[0]),
        .i1(b[0]),
        .eq(e0)
    );
    
    // Bit 1
    eq1 eq_bit1_unit(
        .i0(a[1]),
        .i1(b[1]),
        .eq(e1)
    );
    
    // a and b are equal if individual bits are equal
    assign aeqb = e0 & e1;
    
endmodule