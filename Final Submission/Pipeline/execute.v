`include "alu.v"

module execute(icode,ifun,valA,valB,valC,valE,cond,zf,sf,of,clock);

input clock;
input [3:0] icode,ifun;
input [63:0] valA,valB,valC;

output reg [63:0] valE;
output reg cond,zf,of,sf;   // sf is the signed condition bit and of is the overflow condition bit

reg [1:0] control;
reg signed [63:0] input1,input2;

wire signed [63:0] alu_out;
wire alu_carry_out,alu_overflow_check;

reg x1,x2,or1,or2,and1,and2,not1;
wire xout,andout,orout,notout;

initial begin
    zf=0;
    sf=0;
    of=0;
end

alu alu(.control(control),.input1(input1),.input2(input2),.alu_out(alu_out),.alu_carry_out(alu_carry_out),.alu_overflow_check(alu_overflow_check));


always @(*) begin
    if(icode == 4'b0110 && clock == 1) begin
        zf = (alu_out == 1'b0);
        sf = (alu_out < 1'b0);
        of = alu_overflow_check;
    end    
end

initial begin
    control = 2'd0;
    input1 = 64'd0;
    input2 = 64'd0;
end

xor g1(xout,x1,x2);
or g2(orout,or1,or2);
and g3(andout,and1,and2);
not g4(notout,not1);


// below is procedural block to assign different values based on icode and ifun
always @(*) begin
    if(clock == 1) begin
        cond = 0;
        if(icode == 4'b0010 && ifun==4'b0000) begin
           cond = 1;
           valE = valA; 
        end
        else if(icode == 4'b0010 && ifun==4'b0001) begin
            x1 = sf;
            x2 = of;
            if(xout || zf)
                cond = 1;
            valE = valA;
        end
        else if(icode == 4'b0010 && ifun==4'b0010) begin
            x1 = sf;
            x2 = of;
            if(xout)
                cond = 1;
            valE = valA;
        end
        else if(icode == 4'b0010 && ifun==4'b0011 && zf) begin
           cond = 1;
           valE = valA; 
        end
        else if(icode == 4'b0010 && ifun==4'b0100 && !zf) begin
           cond = 1;
           valE = valA; 
        end
        else if(icode == 4'b0010 && ifun==4'b0101) begin
            x1 = of;
            x2 = sf;
            not1 = xout;
            if(notout == 1)
                cond = 1;
            valE = valA;
        end
        else if(icode == 4'b0010 && ifun==4'b0110) begin
            x1 = of;
            x2 = sf;
            not1 = xout;
            if(notout && !zf)
                cond = 1;
            valE = valA;
        end
        else if(icode == 4'b0011)
            valE = valC;
        else if(icode == 4'b0100 || icode==4'b0101)
            valE=valB+valC;
        else if(icode==4'b0110) begin
            if(ifun==4'b0000) begin
               control = 2'd0;
               input1 = valA;
               input2 = valB;
            end
            else if(ifun == 4'b0001)begin
                control=2'd1;
                input1 = valB;
                input2 = valA;
            end
            else if(ifun == 4'b0010)begin
                control=2'd2;
                input1 = valA;
                input2 = valB;
            end
            else if(ifun == 4'b0010)begin
                control=2'd3;
                input1 = valA;
                input2 = valB;
            end
            valE = alu_out;
        end
        else if(icode==4'b0111) begin
            if(ifun == 4'b0000)
                cond = 1;
            else if(ifun == 4'b0001) begin
                x1 = sf;
                x2 = of;
                if(xout || zf)
                    cond = 1;
            end
            else if(ifun == 4'b0010) begin
                x1 = sf;
                x2 = of;
                if(xout)
                    cond = 1;
            end
            else if(ifun==4'b0011 && zf)
                cond = 1;
            else if(ifun==4'b0100 && !zf)
                cond = 1;
            else if(ifun==4'b0101) begin
                x1 = of;
                x2 = sf;
                not1 = xout;
                if(notout == 1)
                    cond = 1;
            end
            else if(ifun==4'b0110) begin
                x1 = of;
                x2 = sf;
                not1 = xout;
                if(notout && !zf)
                    cond = 1;
            end
        end
        else if(icode == 4'b1000)
            valE = valB + (-64'd8);
        else if(icode == 4'b1001)
            valE = 64'd8 + valB;
        else if(icode == 4'b1010)
            valE = valB + (-64'd8);
        else if(icode==4'b1011)
            valE = 64'd8 + valB;
   end
end
endmodule