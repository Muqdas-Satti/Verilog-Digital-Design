`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 08:34:49 AM
// Design Name: 
// Module Name: counter_16bit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_16bit_tb;

reg clk;
reg rst;
wire [15:0] count;
    
counter_16bit uut(
.clk(clk),
.rst(rst),
.count(count));

initial
 begin
        clk = 0;
        forever #5 clk = ~clk; 
end 

 initial 
 begin
        rst = 1;
        #10 rst = 0; // Release reset after 10ns

        #100;
        $stop; // End simulation
 end
 
   initial begin
        $monitor("Time=%0t | Reset=%b | Count=%d", $time, rst, count);
    end

endmodule


    
    

