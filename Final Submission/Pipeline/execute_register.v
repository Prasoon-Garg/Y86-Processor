`timescale 1ns / 1ps

module execute_register(d_icode,d_ifun,d_regA,d_regB,d_valC,d_valP,d_valA,d_valB,e_icode,e_ifun,e_regA,e_regB,e_valC,e_valP,e_valA,e_valB,clock);  
input clock;

input [3:0] d_icode,d_ifun,d_regA,d_regB;
input [63:0] d_valC,d_valP,d_valA,d_valB;
output reg [3:0] e_icode,e_ifun,e_regA,e_regB;
output reg [63:0] e_valC,e_valP,e_valA,e_valB;

always@(posedge clock)
begin
  e_icode <=  d_icode;     
  e_ifun <=  d_ifun;    
  e_regA <=  d_regA;  
  e_regB <=  d_regB;  
  e_valC <=  d_valC;    
  e_valP <=  d_valP;    
  e_valA <=  d_valA;    
  e_valB <=  d_valB;    
end
endmodule