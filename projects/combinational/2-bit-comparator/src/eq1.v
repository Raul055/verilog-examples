module eq1
    (
        // I/O ports
        input wire i0, i1,
        output wire eq
    );
    
    // Signal declaration
    wire p0, p1;
    
    /* Body */
    // Sum of two product terms
    assign eq = p0 | p1;
    // Product terms
    assign p0 = ~i0 & ~i1;
    assign p1 = i0 & i1;
    
endmodule