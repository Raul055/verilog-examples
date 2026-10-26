module decoder
    #(
        parameter N_in=4,
        parameter N_out=16
    )
    (
        input [N_in-1:0] in,
        output reg [N_out-1:0] out
    );
    
    // Decoder
    always @(*)
    begin
        out = 0;
        out[in] = 1'b1;
    end
    
endmodule
