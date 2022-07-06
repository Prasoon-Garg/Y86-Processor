`timescale 1ns / 1ps

module fetch_register(pred_pc,f_pred_pc,clock);  
  input clock;
  input [63:0] pred_pc;
  output reg [63:0] f_pred_pc;

  always@(posedge clock)
  begin
    f_pred_pc <= pred_pc;
  end
endmodule