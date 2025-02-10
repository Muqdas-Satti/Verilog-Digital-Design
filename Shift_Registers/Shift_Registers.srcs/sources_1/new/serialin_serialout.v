`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2025 10:39:21 AM
// Design Name: 
// Module Name: parallin_serialout
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


module parallin_serialout(
    input clk,
    input rst,
    input [7:0] data_in,
    input load,
    output reg data_out
    );
 reg [7:0] shift_reg;
 reg [2:0] count;
 always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
            count <= 3'b000;
        end 
        else begin
            shift_reg <= {shift_reg[6:0], data_in}; 
            count <= count + 1;
            
            if (count == 3'b111) 
            begin
                data_out <= {shift_reg[6:0], data_in};
                count <= 3'b000; 
            end
        end
    end
endmodule