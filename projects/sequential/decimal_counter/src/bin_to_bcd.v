/* 
    =================================================================
    Returns the ones, tens, hundred & thousands from a binary value
    =================================================================
    Uses the Double Dabble algorithm for bin to BCD
    =================================================================
*/

module bin_to_bcd
    #(parameter bit_bin=14)
    (
        // By default, 14-bit number (0-16383)
        input wire [bit_bin-1:0] bin,
        
        // All 4-bit values for normal decimal (0-9)
        // By default, cannot get NXXXX (N-digit)
        output reg [3:0] thousands,
        output reg [3:0] hundreds,
        output reg [3:0] tens,
        output reg [3:0] ones
    );
    
    // For for loop
    integer i;
    
    always @(*)
    begin
        // All initiate as zero
        thousands   = 4'd0;
        hundreds    = 4'd0;
        tens        = 4'd0;
        ones        = 4'd0;

        // Start at MSB
        for (i = bit_bin-1; i >= 0; i = i - 1)
            begin
                // Check if BCD >= 5, add 3 if so
                if (thousands >= 5) thousands = thousands + 3;
                if (hundreds  >= 5) hundreds  = hundreds  + 3;
                if (tens      >= 5) tens      = tens      + 3;
                if (ones      >= 5) ones      = ones      + 3;
    
                // Shift everything 1-bit
                thousands = {thousands[2:0], hundreds[3]};
                hundreds  = {hundreds[2:0], tens[3]};
                tens      = {tens[2:0], ones[3]};
                ones      = {ones[2:0], bin[i]};
            end
    end
    
endmodule