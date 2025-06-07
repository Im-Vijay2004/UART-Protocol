module DEBOUNCER(sys_clk,in,out);
input sys_clk,in;
output reg out;
reg [24:0] count;
always @(posedge sys_clk)
begin
    if(in) // 10000000 equal to 100 ms at 100MHz Clock
    begin
        if(count==10000000)
        begin
            out<=1;
            count<=0;
        end
        else
        begin
            count<=count+1;
            out<=0;
        end
    end
    else
    begin
        out<=0;
        count<=0;
    end
end
endmodule