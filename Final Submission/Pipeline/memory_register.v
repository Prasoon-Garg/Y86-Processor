`timescale 1ns / 1ps

module memory_register(e_icode,e_regA,e_regB,e_valC,e_valP,e_valA,e_valB,e_cond,e_valE,m_icode,m_regA,m_regB,m_valC,m_valP,m_valA,m_valB,m_cond,m_valE,clock);  
input clock;

input [3:0] e_icode,e_regA,e_regB;
input [63:0] e_valC,e_valP,e_valA,e_valB,e_valE;
input e_cond;

output reg [3:0] m_icode,m_regA,m_regB;
output reg [63:0] m_valC,m_valP,m_valA,m_valB,m_valE;
output reg m_cond;

always@(posedge clock)
begin
  m_icode <= e_icode;
  m_regA <= e_regA;
  m_regB <= e_regB;
  m_valC <= e_valC;
  m_valP <= e_valP;
  m_valA <= e_valA;
  m_valB <= e_valB;
  m_cond <= e_cond;
  m_valE <= e_valE;
end
endmodule