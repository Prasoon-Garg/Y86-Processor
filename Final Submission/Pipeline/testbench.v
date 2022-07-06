`timescale 1ns / 1ps

`include "decode_register.v"
`include "execute_register.v"
`include "fetch_register.v"
`include "memory_register.v"
`include "write_back_register.v"
`include "instruct_fetch.v"
`include "execute.v"
`include "decode_write.v"
`include "memory.v"
`include "pc_update.v"

module testbench;

reg clock;
reg [63:0] pc_val;
reg [2:0] stat;

// declaring registers for register file
wire [63:0] rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;

// fetch stage register declarations
wire [3:0] f_icode,f_ifun,f_regA,f_regB; 
wire [63:0] f_valC,f_valP,f_pred_pc;
wire instruct_valid,mem_error,halt;
wire [63:0] pc_new;

// decode stage register declarations
wire [3:0] d_icode,d_ifun,d_regA,d_regB; 
wire [63:0] d_valA,d_valB,d_valC,d_valP;


// execute stage register declarations
wire [3:0] e_icode,e_ifun,e_regA,e_regB; 
wire [63:0] e_valA,e_valB,e_valC,e_valE,e_valP;
wire e_cond;


// memory stage register declarations
wire [3:0] m_icode,m_regA,m_regB; 
wire [63:0] m_valA,m_valB,m_valC,m_valE,m_valM,m_valP;
wire m_cond;


// write back register declarations
wire [3:0] w_icode,w_regA,w_regB; 
wire [63:0] w_valA,w_valB,w_valC,w_valE,w_valM,w_valP;
wire w_cond;


// Modules initialisation in main file
instruct_fetch instruct_fetch(.icode(f_icode),.ifun(f_ifun),.pc_val(pc_val),.regA(f_regA),.regB(f_regB),.valC(f_valC),.valP(f_valP),.instruct_valid(instruct_valid),.mem_error(mem_error),.halt(halt),.clock(clock));
decode_write decode_write(.d_icode(d_icode),.w_icode(w_icode),.d_regA(d_regA),.w_regA(w_regA),.d_regB(d_regB),.w_regB(w_regB),.d_valA(d_valA),.d_valB(d_valB),.w_valE(w_valE),.w_valM(w_valM),.w_cond(w_cond),.rax(rax),.rcx(rcx),.rdx(rdx),.rbx(rbx),.rsp(rsp),.rbp(rbp),.rsi(rsi),.rdi(rdi),.r8(r8),.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.clock(clock));
execute execute(.icode(e_icode),.ifun(e_ifun),.valA(e_valA),.valB(e_valB),.valC(e_valC),.valE(e_valE),.zf(zf),.sf(sf),.of(of),.cond(e_cond),.clock(clock));
memory memory(.icode(m_icode),.valA(m_valA),.valB(m_valB),.valE(m_valE),.valP(m_valP),.valM(m_valM),.clock(clock));
pc_update pc_update(.pc_val(pc_val),.icode(f_icode),.valC(d_valC),.valM(m_valM),.valP(f_pred_pc),.pc_new(pc_new),.clock(clock),.cond(cond));

// Register initialisation in main file for various stages of pipeline
fetch_register fetch_register(.pred_pc(f_valP),.f_pred_pc(f_pred_pc),.clock(clock));
decode_register decode_register(.f_icode(f_icode),.f_ifun(f_ifun),.f_regA(f_regA),.f_regB(f_regB),.f_valC(f_valC),.f_valP(f_valP),.d_icode(d_icode),.d_ifun(d_ifun),.d_regA(d_regA),.d_regB(d_regB),.d_valC(d_valC),.d_valP(d_valP),.clock(clock));
execute_register execute_register(.d_icode(d_icode),.d_ifun(d_ifun),.d_regA(d_regA),.d_regB(d_regB),.d_valC(d_valC),.d_valP(d_valP),.d_valA(d_valA),.d_valB(d_valB),.e_icode(e_icode),.e_ifun(e_ifun),.e_regA(e_regA),.e_regB(e_regB),.e_valC(e_valC),.e_valP(e_valP),.e_valA(e_valA),.e_valB(e_valB),.clock(clock));
memory_register memory_register(.e_icode(e_icode),.e_regA(e_regA),.e_regB(e_regB),.e_valC(e_valC),.e_valP(e_valP),.e_valA(e_valA),.e_valB(e_valB),.e_cond(e_cond),.e_valE(e_valE),.m_icode(m_icode),.m_regA(m_regA),.m_regB(m_regB),.m_valC(m_valC),.m_valP(m_valP),.m_valA(m_valA),.m_valB(m_valB),.m_cond(m_cond),.m_valE(m_valE),.clock(clock));
write_back_register write_back_register(.clock(clock),.m_icode(m_icode),.m_regA(m_regA),.m_regB(m_regB),.m_valC(m_valC),.m_valP(m_valP),.m_valA(m_valA),.m_valB(m_valB),.m_cond(m_cond),.m_valE(m_valE),.m_valM(m_valM),.w_icode(w_icode),.w_regA(w_regA),.w_regB(w_regB),.w_valC(w_valC),.w_valP(w_valP),.w_valA(w_valA),.w_valB(w_valB),.w_cond(w_cond),.w_valE(w_valE),.w_valM(w_valM));

always #5 clock=~clock;

  initial begin
    $dumpfile("out.vcd");
    $dumpvars(0,testbench);
    stat[0] = 1'd1;
    stat[1] = 1'd0;
    stat[2] = 1'd0;
    clock = 0;
    pc_val = 64'd2;
  end 

  always@(*)
  begin
    pc_val = pc_new;
  end

  always@(*)
  begin
    if(halt)
    begin
        stat[0] = 1'b0;
        stat[1] = 1'b0;
        stat[2] = 1'b1;
    end
    else if(instruct_valid)
    begin
        stat[0] = 1'b0;
        stat[1] = 1'b1;
        stat[2] = 1'b0;
    end
    else
    begin
        stat[0] = 1'b1;
        stat[1] = 1'b0;
        stat[2] = 1'b0;
    end
  end
  
  always@(*)
  begin
    if(stat[2]==1'b1)
    begin
      $finish;
    end
  end

  initial begin
    $monitor("clock=%d f=%d d=%d e=%d m=%d wb=%d",clock,f_icode,d_icode,e_icode,m_icode,w_icode);
  end
endmodule