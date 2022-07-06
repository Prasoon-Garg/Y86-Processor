`timescale 1ns / 1ps

module decode_register(f_icode,f_ifun,f_regA,f_regB,f_valC,f_valP,d_icode,d_ifun,d_regA,d_regB,d_valC,d_valP,clock);  
input clock;
input [3:0] f_icode,f_ifun,f_regA,f_regB;
input [63:0] f_valC;
input [63:0] f_valP;
output reg [3:0] d_icode,d_ifun,d_regA,d_regB;
output reg [63:0] d_valC,d_valP;

always@(posedge clock) begin
    d_icode <= f_icode;
    d_ifun <= f_ifun;
    d_regA <= f_regA;
    d_regB <= f_regB;
    d_valC <= f_valC;
    d_valP <= f_valP;
end
endmodule