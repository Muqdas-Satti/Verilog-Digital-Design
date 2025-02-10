`timescale 1ns / 1ps

module tb_serialin_serialout();

    reg clk;
    reg rst;
    reg data_in;
    wire [7:0] data_out;
    
    // Instantiate the DUT (Device Under Test)
    serialin_serialout uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period
    
    initial begin
        clk = 0;
        rst = 1;  
        #10 data_in = 1;
 
        #20 rst = 0; 
        
        #10 data_in = 0;
        #10 data_in = 1;
        #10 data_in = 1;
        #10 data_in = 0;
        #10 data_in = 0;
        #10 data_in = 1;
        #10 data_in = 1;
       
       
        #100;

        rst = 1;
        #20 rst = 0;
        
        #100;
        $stop; // Stop simulation
    end
endmodule
