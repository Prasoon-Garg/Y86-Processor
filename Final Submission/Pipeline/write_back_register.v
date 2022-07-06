`timescale 1ns / 1ps

module write_back_register(clock,m_icode,m_regA,m_regB,m_valC,m_valP,m_valA,m_valB,m_cond,m_valE,m_valM,w_icode,w_regA,w_regB,w_valC,w_valP,w_valA,w_valB,w_cond,w_valE,w_valM);  
input clock;

input [3:0] m_icode,m_regA,m_regB;
input [63:0] m_valC,m_valP,m_valA,m_valB,m_valE,m_valM;
input m_cond;

output reg [3:0] w_icode,w_regA,w_regB;
output reg [63:0] w_valC,w_valP,w_valA,w_valB,w_valE,w_valM;
output reg w_cond;

always@(posedge clock)
begin
  w_icode <= m_icode;
  w_regA <= m_regA;
  w_regB <= m_regB;
  w_valC <= m_valC;
  w_valP <= m_valP;
  w_valA <= m_valA;
  w_valB <= m_valB;
  w_cond <= m_cond;
  w_valE <= m_valE;
  w_valM <= m_valM;
end
endmodule