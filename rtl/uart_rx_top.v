module uart_rx_top (
    input clk, 
    input rst, 
    input rx_in, 
    output rx_valid,
    output [7:0] rx_out
);

    wire sample_tick; 
    baud_generator#(50000000, 115200) gen(clk, rst, sample_tick); 
    uart_rx receiver(clk, rst, rx_in, sample_tick, rx_out, rx_valid); 

endmodule 