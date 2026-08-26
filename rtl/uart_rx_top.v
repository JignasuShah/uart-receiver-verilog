module uart_rx_top #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
) (
    input clk, 
    input rst, 
    input rx_in, 
    output rx_valid,
    output [7:0] rx_out
);

    wire sample_tick; 
    baud_generator#(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) gen(.clk(clk), .rst(rst), .sample_tick(sample_tick)); 
    uart_rx receiver(.clk(clk), .rst(rst), .rx_in(rx_in), .rx_en(sample_tick), .rx_out(rx_out), .rx_valid(rx_valid)); 

endmodule 