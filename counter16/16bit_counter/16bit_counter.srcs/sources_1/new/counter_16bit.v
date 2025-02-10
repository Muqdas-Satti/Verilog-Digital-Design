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
    input enb,
    input up,
    input load_enb,
    input [3:0] load,
    output reg[3:0 ]count
    );
initial
begin
 count = 4'b0;
 end
always @(posedge clk)
    begin
       if(rst)
          count<=4'b0;
       else if(load_enb)
          count<=load;   
       else if(enb)
          count<=up? count+1:count-1;                            
    end
endmodule
