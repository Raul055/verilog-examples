module hex_to_7_seg_top
    (
        /* I/O declaration */
        input wire [4:0] sw,
        output wire [3:0] an,
        output wire [7:0] seg   
    );
    
    /* Signal declaration */
    wire [3:0] hex_bits;    // Checks hex number 
    wire dp_enable;         // Bit to enable decimal pont
    
    /* Assign */
    assign an = 4'b1110;        // Enable the last digit of the display (EN: LOW)
    assign hex_bits = sw[3:0];  // Takes first three to use the hex bits
    assign dp_enable = sw[4];   // Last bit to enable decimal point
    
    hex_to_7_seg display_driver (
        .hex (hex_bits),
        .dp (dp_enable),
        ._7_seg (seg)
    );

endmodule
