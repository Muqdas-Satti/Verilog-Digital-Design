module uart #(
    parameter CLK_FREQ = 50000000,  // Clock frequency in Hz
    parameter BAUD_RATE = 9600      // Baud rate
)(
    input wire clk,                 // Clock signal
    input wire rst_n,               // Active-low reset
    input wire tx_start,            // Start transmission signal
    input wire [7:0] tx_data,       // Data to transmit
    output reg tx,                  // Transmit data line
    output reg tx_busy,             // Transmitter busy flag
    input wire rx,                  // Receive data line
    output reg rx_ready,            // Receive data ready flag
    output reg [7:0] rx_data        // Received data
);

    localparam CLK_DIV = CLK_FREQ / BAUD_RATE;

    // Transmitter logic
    reg [3:0] tx_bit_cnt;          
    reg [10:0] tx_shift_reg;        // Shift register for transmission (1 start bit, 8 data bits, 1 stop bit)
    reg [15:0] tx_clk_cnt;          // Clock counter for baud rate generation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1'b1;             // Idle state is high
            tx_busy <= 1'b0;
            tx_bit_cnt <= 4'd0;
            tx_shift_reg <= 11'b0;
            tx_clk_cnt <= 16'd0;
        end else begin
            if (tx_start && !tx_busy) begin
                tx_busy <= 1'b1;
                tx_shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit (0), data bits, stop bit (1)
                tx_bit_cnt <= 4'd0;
                tx_clk_cnt <= 16'd0;
            end

            if (tx_busy) begin
                if (tx_clk_cnt == CLK_DIV - 1) begin
                    tx_clk_cnt <= 16'd0;
                    tx <= tx_shift_reg[0];
                    tx_shift_reg <= {1'b1, tx_shift_reg[10:1]};
                    if (tx_bit_cnt == 4'd10) begin
                        tx_busy <= 1'b0;
                    end else begin
                        tx_bit_cnt <= tx_bit_cnt + 4'd1;
                    end
                end 
                else
                 begin
                    tx_clk_cnt <= tx_clk_cnt + 16'd1;
                end
            end
        end
    end

    // Receiver logic
    reg [3:0] rx_bit_cnt;           // Bit counter for reception
    reg [7:0] rx_shift_reg;         // Shift register for reception
    reg [15:0] rx_clk_cnt;          // Clock counter for baud rate generation
    reg rx_sample;                  // Sample signal for receiving data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_ready <= 1'b0;
            rx_data <= 8'd0;
            rx_bit_cnt <= 4'd0;
            rx_shift_reg <= 8'd0;
            rx_clk_cnt <= 16'd0;
            rx_sample <= 1'b0;
        end else begin
            if (!rx_sample) begin
                if (!rx) begin // Start bit detected
                     rx_clk_cnt <= rx_clk_cnt + 16'd1;

                    if(rx_clk_cnt == CLK_DIV  - 1)
                      begin
                        rx_sample <= 1'b1;
                        rx_clk_cnt <= 16'd0;

                       end 
                    rx_bit_cnt <= 4'd0;
                end
            end else begin
                if (rx_clk_cnt == CLK_DIV  - 1)begin
                    rx_clk_cnt <= 16'd0;
                    if (rx_bit_cnt == 4'd8) begin
                        rx_sample <= 1'b0;
                        rx_ready <= 1'b1;
                        rx_data <= rx_shift_reg;
                    end else begin
                        rx_shift_reg <= {rx, rx_shift_reg[7:1]};
                        rx_bit_cnt <= rx_bit_cnt + 4'd1;
                    end
                end else begin
                    rx_clk_cnt <= rx_clk_cnt + 16'd1;
                end
            end
        end
    end

endmodule