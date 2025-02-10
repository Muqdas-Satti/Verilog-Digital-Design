
 
 `timescale 1ns / 1ps

module tb_serialin_serialout;

    // Testbench signals
    reg clk;
    reg rst;
    reg data_in;
    wire dout;
    
    // Instantiate the DUT (Device Under Test)
    serialin_serialout uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (50 MHz -> 20 ns period)
    always #10 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        data_in = 0;

        // Reset the shift register
        #20 rst = 0;

        // Apply test pattern
        #20 data_in = 1; // Shift in '1'
        #20 data_in = 0; // Shift in '0'
        #20 data_in = 1; // Shift in '1'
        #20 data_in = 1; // Shift in '1'
        #20 data_in = 0; // Shift in '0'
        #20 data_in = 1; // Shift in '1'
        #20 data_in = 1; // Shift in '1'
        #20 data_in = 0; // Shift in '0'

        // Observe results
        #100 $stop;
    end

endmodule

 
 
 



