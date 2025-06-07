module UART_RX#(parameter data_bits=8)(clk,rst,rx,baud_tick,rx_done,data_out);
input clk,rst,rx,baud_tick;
output reg rx_done;
output reg [data_bits-1:0] data_out;

// FSM States
localparam  idle=0,
            start=1,
            data_transfer=2,
            stop=3;
reg [1:0] state;
reg [3:0] baud_count;
reg [2:0] bit_count;
reg [data_bits-1:0] rx_data; // Temporary register to story data_out
always @(posedge clk)
begin
    if(rst)
    begin
        state<=idle;
        rx_done<=0;
        baud_count<=0;
        bit_count<=0;
        rx_data<=0;
        data_out<=0;
    end
    else
    begin
        case(state)
            idle:
                begin
                    rx_done<=0;
                    rx_data<=0;
                    if(~rx)
                    begin
                        state<=start;
                        baud_count<=0;
                    end
                    // No need of else
                end
            start:
                begin
                    if(baud_tick)
                    begin
                        if(baud_count==7)
                        begin
                            baud_count<=0;
                            state<=data_transfer;
                            bit_count<=0;
                        end
                        else
                            baud_count<=baud_count+1;
                    end
                    // No need of else
                end
            data_transfer:
                begin
                    if(baud_tick)
                    begin
                        if(baud_count==15)
                        begin
                            baud_count<=0;
                            rx_data[bit_count] <= rx;
                            if(bit_count==7)
                            begin
                                bit_count<=0;
                                state<=stop;
                            end
                            else
                            begin
                                bit_count<=bit_count+1;
                            end
                        end
                        else
                            baud_count<=baud_count+1;
                    end
                    // No need of Else
                end
                
            stop:
                begin
                    if(baud_tick)
                    begin
                        data_out<=rx_data;
                        if(baud_count==15)
                        begin
                            rx_done<=1;
                            state<=idle;
                            baud_count<=0;
                        end
                        else
                            baud_count<=baud_count+1;
                    end
                    // No need of else
                end   
            default:
                begin
                    state<=idle;
                    data_out<=0;
                end    
        endcase
    end
end
endmodule
