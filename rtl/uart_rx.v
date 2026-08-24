module uart_rx (
    input clk, 
    input rst, 
    input rx_in, 
    input baud_tick,
    output reg [7:0] rx_out, 
    output reg rx_valid
); 

    reg [1:0] state_reg, next_state; 
    reg [2:0] bit_counter; 
    reg [7:0] bit_reg; 
    

    localparam IDLE = 2'b00; 
    localparam START = 2'b01; 
    localparam IN_STREAM = 2'b10; 
    localparam STOP = 2'b11; 
    

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= IDLE;
        end
        else begin
            state_reg <= next_state; 
        end
    end


    always @(posedge clk) begin
        if (rst) begin
            bit_counter <= 3'd0; 
            bit_reg <= 8'd0; 
            rx_out <= 8'd0; 
            rx_valid <= 1'd0;
        end
        else if (state_reg == IDLE) begin
            bit_counter <= 3'd0; 
            bit_reg <= 8'd0; 
        end
        else if (state_reg == IN_STREAM && baud_tick) begin
            bit_reg <= {rx_in, bit_reg[7:1]}; 
            bit_counter <= bit_counter + 1; 
        end
        else if (state_reg == STOP && baud_tick && rx_in) begin
            rx_valid <= 1'b1; 
            rx_out <= bit_reg; 
        end
        else begin
            rx_valid <= 1'b0;
        end
    end

    always @(*) begin

        next_state = state_reg; 

        case (state_reg) 
        IDLE: begin
        

            if (~rx_in) begin
                next_state = START; 
            end
            else begin
                next_state = IDLE; 
            end
        end

        START: begin
            
            if (baud_tick) begin
                next_state = IN_STREAM;
            end 
            else begin
                next_state = START; 
            end
        end


        IN_STREAM: begin

            if (baud_tick && bit_counter == 7) begin
                next_state = STOP; 
            end
            else begin
                next_state = IN_STREAM;
            end
        end

        STOP: begin
            if (rx_in && baud_tick) begin
                next_state = IDLE; 
            end
        end
        endcase
    end



endmodule 