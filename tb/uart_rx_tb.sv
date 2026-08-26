'timescale 1ns/1ps

module uart_rx_tb; 

reg clk; 
reg rst; 
reg rx_in; 

wire rx_valid; 
wire rx_out; 

uart_rx_top #(.CLK_FREQ(50000000), .BAUD_RATE(115200)) dut (.clk(clk), .rst(rst), .rx_in(rx_in), .rx_valid(rx_valid), .rx_out(rx_out)); 

initial clk = 1'b0; 
always #10 clk = ~clk; 

initial begin
    rst = 1'b1; 
    rx_in = 1'b1; 
    #40; 
    rst = 1'b0; 
end

endmodule 