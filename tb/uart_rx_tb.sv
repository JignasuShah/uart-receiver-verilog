'timescale 1ns/1ps

module uart_rx_tb; 

reg clk; 
reg rst; 
reg rx_in; 

wire rx_valid; 
wire rx_out; 

uart_rx_top #(.CLK_FREQ(50000000), .BAUD_RATE(115200)) dut (.clk(clk), .rst(rst), .rx_in(rx_in), .rx_valid(rx_valid), .rx_out(rx_out)); 


endmodule 