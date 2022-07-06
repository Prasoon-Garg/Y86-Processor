module pc_update(pc_val,icode,valC,valM,valP,pc_new,clock,cond);

input [63:0] pc_val,valC,valM,valP;
input [3:0] icode;
input clock,cond;
output reg [63:0] pc_new;

always@(*) begin
    if(icode == 4'b1000)
        pc_new = valC;
    else if(icode == 4'b1001)
        pc_new = valM;
    else if(icode == 4'b0111)
    begin
        if(cond == 1'b1)
            pc_new = valC;
        else
            pc_new = valP;
    end
    else
        pc_new = valP;
end
endmodule