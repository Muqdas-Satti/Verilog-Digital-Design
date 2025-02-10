`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 08:28:54 AM
// Design Name: 
// Module Name: counter_16bit
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


module counter_16bit(
    input clk,
    input rst,
    output reg[15:0 ]count
    );
initial count = 16'b0;
    always @(posedge clk)
    begin
       if(rst)
          count<=16'b0;
       else
          count<=count+1;          
    end
endmodule
