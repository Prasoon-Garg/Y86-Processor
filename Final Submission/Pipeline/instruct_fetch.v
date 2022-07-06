module instruct_fetch(icode,ifun,pc_val,regA,regB,valC,valP,instruct_valid,mem_error,halt,clock);

input clock;
input [63:0] pc_val;
output reg [3:0] icode,ifun,regA,regB;
output reg [63:0] valC,valP;
output reg instruct_valid,mem_error,halt; // instruct_valid = 1 implies that valid

reg [7:0] instruction_memory[0:1023];


initial begin
//OPq
    instruction_memory[2]=8'b01100000;
    instruction_memory[3]=8'b00100011;
    instruction_memory[4]=8'b00010000;
    instruction_memory[5]=8'b00010000;
    instruction_memory[6]=8'b00010000;
    instruction_memory[7]=8'b00100000;
    instruction_memory[8]=8'b00000100;
    instruction_memory[9]=8'b00010000;
    instruction_memory[10]=8'b00010000;
    instruction_memory[11]=8'b00010000;
    instruction_memory[12]=8'b00010000;
    instruction_memory[13]=8'b00010000;
    instruction_memory[14]=8'b00010000;
    instruction_memory[15]=8'b00000000;
end


always @ (posedge clock)
begin
    mem_error = 0;
    if(pc_val > 1023)
    begin
        mem_error = 1;
    end

    icode = instruction_memory[pc_val][7:4];
    ifun = instruction_memory[pc_val][3:0];

    instruct_valid = 1;

    if(icode==4'b0000) //halt
    begin
      halt=1;
      valP=pc_val+64'd1;
    end
    else if(icode==4'b0001) //nop
    begin
      valP=pc_val+64'd1;
    end
    else if(icode==4'b0010 || icode==4'b0110 || icode==4'b1010 || icode==4'b1011) //rrmovq , OPq , pushq , popq
    begin
      regA=instruction_memory[pc_val+1][7:4];
      regB=instruction_memory[pc_val+1][3:0];
      valP=pc_val+64'd2;
    end
    else if(icode==4'b0011 || icode==4'b0100 || icode==4'b0101) //irmovq , rmmovq , mrmovq
    begin
      regA=instruction_memory[pc_val+1][7:4];
      regB=instruction_memory[pc_val+1][3:0];
      valC={instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8],instruction_memory[pc_val+9]};
      valP=pc_val+64'd10;
    end
    else if(icode==4'b0111 || icode==4'b1000) //jxx , call
    begin
      valC={instruction_memory[pc_val+1],instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8]};
      valP=pc_val+64'd9;
    end
    else if(icode==4'b1001) //ret
    begin
      valP=pc_val+64'd1;
    end
    else 
    begin
      instruct_valid=1'b0;
    end
end
endmodule