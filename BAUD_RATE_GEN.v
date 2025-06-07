module BAUD_RATE_GEN#(parameter sys_clk=100000000,baud_rate=9600,smp_rate=16)(clk,rst,baud_tick);
input clk,rst;
output reg baud_tick;

localparam count_max=(sys_clk)/(baud_rate*smp_rate);
localparam count_width=$clog2(count_max);

reg [count_width-1:0] count;

always @(posedge clk)
begin
    if(rst)
    begin
        count<=0;
        baud_tick<=0;
    end
    else
    begin
        if(count<count_max-1)
        begin
            count     <= count+1;
            baud_tick <= 0;
        end
        else
        begin
            count<=0;
            baud_tick<=1;
        end
    end
end
endmodule