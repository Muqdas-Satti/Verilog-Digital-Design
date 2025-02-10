`timescale 1ns/1ps

module uart_tb;

    // Parameters
    parameter CLK_FREQ = 50000000;  // 50 MHz clock
    parameter BAUD_RATE = 9600;     // 9600 baud rate
    parameter CLK_PERIOD = 20;      // 50 MHz → 20 ns per clock
    parameter BIT_PERIOD = (CLK_FREQ / BAUD_RATE); // Number of clock cycles per UART bit

    // Signals
    reg clk;
    reg rst_n;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_busy;
    wire rx_ready;
    wire [7:0] rx_data;
    reg rx; // Change from wire to reg to control it manually

    // Instantiate the UART module
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
        .rx(rx), // Proper RX modeling
        .rx_ready(rx_ready),
        .rx_data(rx_data)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // 20 ns period
    end

    // Simulate RX capturing TX signal with a delay
    task simulate_rx();
        integer i;
        begin
            rx = 1; // Default idle state

            // Wait for TX to start transmission (Start Bit = 0)
            wait(tx == 0);
            # (BIT_PERIOD * CLK_PERIOD); // Align with TX

            // Start bit
            rx = 0;

            // Receive 8 data bits
            for (i = 0; i < 8; i = i + 1) begin
                rx = tx; // Sample TX as RX
                # (BIT_PERIOD * CLK_PERIOD);
            end

            // Stop bit
            rx = 1;
            # (BIT_PERIOD * CLK_PERIOD);
        end
    endtask

    // Testbench stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        tx_start = 1;
        tx_data = 8'hA5;
        rx = 1; // Ensure RX starts in idle state

        // Reset the system
        #100;
        rst_n = 1;
        #100;

        // Send data: 0xA5 (10100101 in binary)
        tx_data = 8'hA5;
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait for transmission to start
        wait(tx_busy);

        // Simulate RX capturing TX data
        simulate_rx();

        // Wait for reception to complete
        wait(rx_ready);

        // Check received data
        if (rx_data == tx_data)
            $display("✅ Test Passed: Transmitted data = %h, Received data = %h", tx_data, rx_data);
        else
            $display("❌ Test Failed: Transmitted data = %h, Received data = %h", tx_data, rx_data);

        // End simulation
        #100;
        $stop;
    end

endmodule
