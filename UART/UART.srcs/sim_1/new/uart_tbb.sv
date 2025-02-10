`timescale 1ns/1ps

module uart_tb;

    // Parameters
    parameter CLK_FREQ = 50000000;  
    parameter BAUD_RATE = 9600;     
    parameter CLK_PERIOD = 20;      
    parameter BIT_PERIOD = (CLK_FREQ / BAUD_RATE); 
    // Signals
    reg clk;
    reg rst_n;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_busy;
    wire rx_ready;
    wire [7:0] rx_data;
    reg rx; 
    uart #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx(rx),
        .rx_ready(rx_ready),
        .rx_data(rx_data)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; 
    end

    task simulate_rx();
        integer i;
        begin
            rx = 1; 
            wait(tx == 0);
            # (BIT_PERIOD * CLK_PERIOD); 
             rx = 0;
            for (i = 0; i < 8; i = i + 1) begin
                rx = tx; 
                # (BIT_PERIOD * CLK_PERIOD);
            end

            rx = 1;
            # (BIT_PERIOD * CLK_PERIOD);
        end
    endtask

    property tx_active;
        @(posedge clk) disable iff (!rst_n)
        tx_start |=> tx_busy until !tx_busy;
    endproperty
    assert property (tx_active) else $error("TX start should assert tx_busy until transmission completes");

    property rx_data_valid;
        @(posedge clk) disable iff (!rst_n)
        rx_ready |-> (rx_data == tx_data);
    endproperty
    assert property (rx_data_valid) else $error("Received data does not match transmitted data");

    initial begin
        rst_n = 0;
        tx_start = 1;
        tx_data = 8'hA5;
        rx = 1; 
        #100;
        rst_n = 1;
        #100;
        tx_data = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;
        wait(tx_busy);
        simulate_rx();
        wait(rx_ready);
        
        if (rx_data == tx_data)
            $display("✅ Test Passed: Transmitted data = %h, Received data = %h", tx_data, rx_data);
        else
            $display("❌ Test Failed: Transmitted data = %h, Received data = %h", tx_data, rx_data);

        #100;
        $stop;
    end

endmodule
