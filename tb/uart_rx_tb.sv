`timescale 1ns/1ps

module uart_rx_tb; 

reg clk; 
reg rst; 
reg rx_in; 

wire rx_valid; 
wire [7:0] rx_out; 

uart_rx_top #(.CLK_FREQ(50000000), .BAUD_RATE(115200)) dut (.clk(clk), .rst(rst), .rx_in(rx_in), .rx_valid(rx_valid), .rx_out(rx_out)); 

initial clk = 1'b0; 
always #10 clk = ~clk; 

initial begin
    rst = 1'b1; 
    rx_in = 1'b1; 
    #40; 
    rst = 1'b0; 
    send_byte(8'b10101010, 1'b0);
    #20;
    $finish; 
end

task send_byte (
input [7:0] data, 
input corrupt_stop_bit
);

automatic real bit_rate = 1000000000.0 / 115200; 
integer i; 


rx_in = 1'b0; 
# bit_rate; 

for (i = 0; i < 8; i = i + 1) begin
    
    rx_in = data[i];
    # bit_rate; 
end

rx_in = (corrupt_stop_bit) ? 1'b0 : 1'b1; 
# bit_rate; 

rx_in = 1'b1; 
# bit_rate; 

endtask

endmodule 