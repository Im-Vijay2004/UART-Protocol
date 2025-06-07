module UART_TX#(parameter data_bits=8)(clk,rst,baud_tick,tx_start,data_in,tx,tx_done);
input clk,rst,baud_tick,tx_start;
input [data_bits-1:0] data_in;
output reg tx,tx_done;

// Sates of FSM
localparam  idle=0,
            start=1,
            data_transfer=2,
            stop=3;
reg [1:0] state;
reg [3:0] baud_count;
reg [2:0] bit_count;
reg tx_busy;
reg [data_bits-1:0] tx_data;
always @(posedge clk)
begin
    if(rst)
    begin
        state<=idle;
        tx<=1;
        tx_done<=0;
        tx_busy<=0;
    end
    else
    begin
        case(state)
            idle:
                begin
                    if(tx_start)
                    begin
                        tx_data<=data_in;
                        baud_count<=0;
                        state<=start;
                        tx_done<=0;
                        tx_busy<=1;
                    end
                    // Else block is not necessary
                end
            start:
                begin
                    tx<=0;
                    if(baud_tick)
                    begin
                        if(baud_count==15)
                        begin
                            state<=data_transfer;
                            bit_count<=0;
                            baud_count<=0;
                        end
                        else
                            baud_count<=baud_count+1;
                    end
                    // Else not required
                end
            data_transfer:
                begin
                    if(baud_tick)
                    begin
                        tx<=tx_data[bit_count];
                        
                        if(baud_count==15)
                        begin
                            baud_count<=0;
                            bit_count<=bit_count+1;
                            if(bit_count==data_bits-1)
                            begin
                                state<=stop;
                            end
                            //else not necessary
                        end
                        else
                        begin
                            baud_count<=baud_count+1;
                        end
                    end
                    //else not necessary
                end
            stop:
                begin
                    tx<=1;
                    if(baud_tick)
                    begin
                        if(baud_count==15)
                        begin
                            state<=idle;
                            baud_count<=0;
                            tx_done<=1;
                            tx_busy<=0;
                        end
                        else
                            baud_count<=baud_count+1;
                    end
                    //else not necessary
                end
            default:
                begin
                    state<=idle;
                    tx_busy<=0;
                    tx_done<=0;
                    tx<=1;
                    baud_count<=baud_count;
                end
        endcase
    end
end
endmodule