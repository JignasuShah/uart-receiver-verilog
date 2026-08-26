module baud_generator #(
    parameter CLK_FREQ = 50000000, 
    parameter BAUD_RATE = 115200
) (
    input clk, 
    input rst, 
    output reg sample_tick
); 

    localparam CLKS_PER_BIT = CLK_FREQ / (BAUD_RATE * 8);
    reg [15:0] clock_ticks; 

    always @(posedge clk) begin
        if (rst) begin
            clock_ticks <= 16'd0; 
            sample_tick <= 1'b0; 
        end
        else if (clock_ticks == CLKS_PER_BIT - 1) begin
            clock_ticks <= 16'd0; 
            sample_tick <= 1'b1;
        end
        else begin
            clock_ticks <= clock_ticks + 1; 
            sample_tick <= 1'b0; 
        end
    end


endmodule