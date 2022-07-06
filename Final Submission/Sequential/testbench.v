`timescale 1ns / 1ps

`include "instruct_fetch.v"
`include "execute.v"
`include "decode_write.v"
`include "memory.v"
`include "pc_update.v"

module testbench;

reg clock;
reg stat[0:2];          // indicate the status of the processor
reg [63:0] pc_val;

wire [3:0] icode,ifun,regA,regB; 
wire [63:0] valA,valB,valC,valE,valM,valP;
wire instruct_valid,mem_error,cond,halt;
wire [63:0] pc_new;

wire [63:0] rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;
wire zf,sf,of;

instruct_fetch instruct_fetch(.icode(icode),.ifun(ifun),.pc_val(pc_val),.regA(regA),.regB(regB),.valC(valC),.valP(valP),.instruct_valid(instruct_valid),.mem_error(mem_error),.halt(halt),.clock(clock));
execute execute(.icode(icode),.ifun(ifun),.valA(valA),.valB(valB),.valC(valC),.valE(valE),.zf(zf),.sf(sf),.of(of),.cond(cond),.clock(clock));
decode_write decode_write(.icode(icode),.regA(regA),.regB(regB),.valA(valA),.valB(valB),.valE(valE),.valM(valM),.rax(rax),.rcx(rcx),.rdx(rdx),.rbx(rbx),.rsp(rsp),.rbp(rbp),.rsi(rsi),.rdi(rdi),.r8(r8),.r9(r9),.r10(r10),.r11(r11),.r12(r12),.r13(r13),.r14(r14),.clock(clock),.cond(cond));

memory mem(.icode(icode),.valA(valA),.valB(valB),.valE(valE),.valP(valP),.valM(valM),.clock(clock));
pc_update pcup(.pc_val(pc_val),.icode(icode),.valC(valC),.valM(valM),.valP(valP),.pc_new(pc_new),.clock(clock),.cond(cond)); 

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

  initial 
		$monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d\n",clock,icode,ifun,regA,regB,valA,valB,valC,valE,valM);
endmodule