module UART_TOP #(parameter data_bits=8)(sys_clk,rst,data_in,start_btn,tx,tx_done,rx,data_out,rx_done,AN,display_out);
input sys_clk,rst,start_btn;
input [data_bits-1:0] data_in;
input rx;
output tx,tx_done,rx_done;
output[data_bits-1:0] data_out;
output [7:0]AN,display_out;

wire tx_start;
wire baud_tick;
DEBOUNCER DEBOUNCING_CKT(sys_clk,start_btn,tx_start); // Debouncer Circuit
// BAUD_RATE_GEN
BAUD_RATE_GEN#(100000000,9600,16)BAUD_GEN(sys_clk,rst,baud_tick);
// Transmitter
UART_TX#(8) TRANSMITTER(sys_clk,rst,baud_tick,tx_start,data_in,tx,tx_done);
UART_RX#(8)RECEIVER(sys_clk,rst,rx,baud_tick,rx_done,data_out);
MULTI_SEG_DISP SEVEN_SEG_DISP(sys_clk,8,data_out[7:4],data_out[3:0],50,50,50,50,data_in[7:4],data_in[3:0],AN,display_out);
endmodule
