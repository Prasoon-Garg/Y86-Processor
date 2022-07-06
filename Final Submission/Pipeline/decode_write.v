module decode_write(d_icode,w_icode,d_regA,w_regA,d_regB,w_regB,d_valA,d_valB,w_valE,w_valM,w_cond,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,clock);

// regA and regB are the registers address whose values are to be fetched from the register fiel
// dstE and dstM are values stored in register file from ALU and Memory respectively
input [3:0] d_regA,d_regB,w_regA,w_regB,d_icode,w_icode;
input clock,w_cond;

// valX is the value associated with the register we are using from the above address
input [63:0] w_valE,w_valM;
output reg [63:0] d_valA,d_valB;
// making the 15 registers as outputs
output reg [63:0] rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14;

// Making an array of registers so that we can access them through arrays
reg [63:0] register_mem[0:14];

// randomly alloting registers some random values for testing
initial begin
    register_mem[0] = 64'd0;
    register_mem[1] = 64'd5;
    register_mem[2] = 64'd10;
    register_mem[3] = 64'd15;
    register_mem[4] = 64'd1000;     // assigning the rsp stack top register as 1000th byte in the memory
    register_mem[5] = 64'd25;
    register_mem[6] = 64'd30;
    register_mem[7] = 64'd35;
    register_mem[8] = 64'd40;
    register_mem[9] = 64'd45;
    register_mem[10] = 64'd50;
    register_mem[11] = 64'd55;
    register_mem[12] = 64'd60;
    register_mem[13] = 64'd65;
    register_mem[14] = 64'd70;
end

// below are the procedural block statements for the decode part
always @(*) begin
    if(d_icode == 4'b0010) // cmmovxx operand valB is zero
        d_valA = register_mem[d_regA];
    else if(d_icode == 4'b0100)   // 
    begin
        d_valA = register_mem[d_regA];
        d_valB = register_mem[d_regB];
    end
    else if(d_icode == 4'b0101)
        d_valB = register_mem[d_regB];
    else if(d_icode == 4'b0110)
    begin
        d_valA = register_mem[d_regA];
        d_valB = register_mem[d_regB];
    end
    else if(d_icode == 4'b1000)
        d_valB = register_mem[4]; // since 4th index is rsp the stack pointer register
    else if(d_icode == 4'b1001)
    begin
        d_valA = register_mem[4]; // accessing the rsp register
        d_valB = register_mem[4];
    end
    else if(d_icode == 4'b1010)
    begin
        d_valA = register_mem[d_regA];
        d_valB = register_mem[4];
    end
    else if(d_icode == 4'b1011)
    begin
        d_valA = register_mem[4]; // accessing the rsp register
        d_valB = register_mem[4];
    end
    rax = register_mem[0];
    rcx = register_mem[1];
    rdx = register_mem[2];
    rbx = register_mem[3];
    rsp = register_mem[4];
    rbp = register_mem[5];
    rsi = register_mem[6];
    rdi = register_mem[7];
    r8 = register_mem[8];
    r9 = register_mem[9];
    r10 = register_mem[10];
    r11 = register_mem[11];
    r12 = register_mem[12];
    r13 = register_mem[13];
    r14 = register_mem[14];
end

// below are the procedural block statements for the write back part

always@(negedge clock) begin
    if(w_icode == 4'b0010 && w_cond == 1'b1)
        register_mem[w_regB] = w_valE;
    else if(w_icode == 4'b0011)
        register_mem[w_regB] = w_valE;
    else if(w_icode == 4'b0101)
        register_mem[w_regA] = w_valM;
    else if(w_icode == 4'b0110)
        register_mem[w_regB] = w_valE;
    else if(w_icode == 4'b1000)
        register_mem[4] = w_valE;
    else if(w_icode == 4'b1001)
        register_mem[4] = w_valE;
    else if(w_icode == 4'b1010)
        register_mem[4] = w_valE;
    else if(w_icode == 4'b1011)
    begin
        register_mem[4] = w_valE;
        register_mem[w_regA] = w_valM;
    end
    rax = register_mem[0];
    rcx = register_mem[1];
    rdx = register_mem[2];
    rbx = register_mem[3];
    rsp = register_mem[4];
    rbp = register_mem[5];
    rsi = register_mem[6];
    rdi = register_mem[7];
    r8 = register_mem[8];
    r9 = register_mem[9];
    r10 = register_mem[10];
    r11 = register_mem[11];
    r12 = register_mem[12];
    r13 = register_mem[13];
    r14 = register_mem[14];
end
endmodule