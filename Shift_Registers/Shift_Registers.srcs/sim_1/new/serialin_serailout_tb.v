`timescale 1ns / 1ps

module tb_parallelin_serialout();

    reg clk;
    reg rst;
    reg load;
    reg [7:0] data_in;
    wire data_out;

    parallelin_serialout uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk
    initial 
    begin
        clk = 0;
        rst = 1;
        load = 0;
        data_in = 8'b0;
        
        #10 rst = 0;  

        #10 load = 1; data_in = 8'b10110011;
        #10 load = 0; 

        #80;

        #10 load = 1; data_in = 8'b11001100;
        #10 load = 0; // Stop loading

        #80;
        $stop;
    end
endmodule
