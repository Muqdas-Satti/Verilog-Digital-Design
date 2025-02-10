`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 10:39:21 AM
// Design Name: 
// Module Name: serialin_serialout
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


module serialin_serialout(
    input clk,
    input rst,
    input data_in,
    output data_out
    );
 reg [7:0] shift_reg;
always @(posedge clk)
begin
 if(rst)
begin
 shift_reg<=8'b0;
end 
else 
begin
  shift_reg <= {shift_reg[6:0],data_in};
 end   
 end
endmodule
