// Timescale
`timescale 1ns/1ps

// Module
module bin_to_vcd_tb;
    // Declare signals to connect to DUT
    // reg ---> inputs
    // wire --> outputs
    reg [13:0] bin;
    wire [3:0] thousands;
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;

    // Instantiate the DUT
    bin_to_bcd uut (
        .bin(bin),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    // Begin test
    initial begin
        // Zero
        bin=0;          #10;

        // Intermediate values
        bin=14'd1;      #10;
        bin=14'd10;     #10;
        bin=14'd100;    #10;
        bin=14'd1000;   #10;
        bin=14'd9999;   #10;
        bin=14'd10000;  #10;

        bin=14'd8;      #10;
        bin=14'd71;     #10;
        bin=14'd436;    #10;
        bin=14'd2330;   #10;
        bin=14'd13522;  #10;

        // Max value
        bin=14'd16383;  #10;
        $finish;
    end

    // Prints results to console
    initial begin
        $monitor("time=%0t bin=(%b | %d) \n--- ones=(%b | %d) --- tens=(%b | %d) --- hundreds=(%b | %d) --- thousands=(%b | %d)---",
                  $time, bin, bin, ones, ones, tens, tens, hundreds, hundreds, thousands, thousands);
    end

    // Dumps .vcd file
    initial begin
        `ifdef VCD_PATH
            $dumpfile(`VCD_PATH);
        `else
            $dumpfile("default.vcd");
        
        `endif
        $dumpvars(0, bin_to_vcd_tb);
    end

endmodule
