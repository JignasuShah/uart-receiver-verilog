module uart_rx (
    input clk, 
    input rst, 
    input rx_in, 
    input rx_en,
    output reg [7:0] rx_out, 
    output reg rx_valid
); 

    reg sync_flipflop_one, sync_flipflop_two; 
    reg [1:0] state_reg, next_state; 
    reg [2:0] bit_counter; 
    reg [2:0] sample_tick_counter; 
    reg [7:0] bit_reg; 
    

    localparam IDLE = 2'b00; 
    localparam START = 2'b01; 
    localparam IN_STREAM = 2'b10; 
    localparam STOP = 2'b11; 
    

    always @(posedge clk) begin
        if (rst) begin
            state_reg <= IDLE;
            bit_counter <= 3'd0; 
            bit_reg <= 8'd0; 
            rx_out <= 8'd0; 
            rx_valid <= 1'd0; 
            sample_tick_counter <= 3'd0; 
        end
        else begin
            state_reg <= next_state; 


            if (state_reg == IDLE) begin
                rx_valid <= 1'd0; 
                bit_counter <= 3'd0; 
                bit_reg <= 8'd0; 
                sample_tick_counter <= 3'd0; 
            end 

            else if (state_reg == START) begin
                if (rx_en) begin
                    if (sample_tick_counter == 3'd3) begin
                        sample_tick_counter <= 3'd0; 
                    end
                    else begin
                        sample_tick_counter <= sample_tick_counter + 1; 
                    end
                end
            end

            else if (state_reg == IN_STREAM) begin
                if (rx_en) begin
                    if (sample_tick_counter == 3'd7) begin
                        sample_tick_counter <= 3'd0; 
                        bit_counter <= bit_counter + 1; 
                        bit_reg <= {sync_flipflop_two, bit_reg[7:1]};
                    end
                    else begin
                        sample_tick_counter <= sample_tick_counter + 1; 
                    end
                end
            end
            

            else if (state_reg == STOP) begin
                if (rx_en) begin
                    sample_tick_counter <= sample_tick_counter + 1; 
                    if (sample_tick_counter == 7 && sync_flipflop_two) begin
                        rx_valid <= 1'b1; 
                        rx_out <= bit_reg; 
                    end
                    else if (sample_tick_counter == 7 && ~sync_flipflop_two) begin
                        rx_valid <= 1'b0; 
                    end
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            sync_flipflop_one <= 1'b1; 
            sync_flipflop_two <= 1'b1; 
        end
        else begin
            sync_flipflop_one <= rx_in; 
            sync_flipflop_two <= sync_flipflop_one; 
        end
        
        
    end


    always @(*) begin

        next_state = state_reg; 

        case (state_reg) 
        IDLE: begin
        

            if (~sync_flipflop_two) begin
                next_state = START; 
            end
            else begin
                next_state = IDLE; 
            end
        end

        START: begin
            
            if (rx_en && sample_tick_counter == 3) begin
                next_state = IN_STREAM;
            end 
            else begin
                next_state = START; 
            end
        end


        IN_STREAM: begin

            if (rx_en && bit_counter == 7 && sample_tick_counter == 7) begin
                next_state = STOP; 
            end
            else begin
                next_state = IN_STREAM;
            end
        end

        STOP: begin
            if (rx_en && sample_tick_counter == 7) begin
                next_state = IDLE; 
            end
        end
        endcase
    end



endmodule 