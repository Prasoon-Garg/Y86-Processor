module instruct_fetch(icode,ifun,pc_val,regA,regB,valC,valP,instruct_valid,mem_error,halt,clock);

input clock;
input [63:0] pc_val;
output reg [3:0] icode,ifun,regA,regB;
output reg [63:0] valC,valP;
output reg instruct_valid,mem_error,halt; // instruct_valid = 1 implies that valid

reg [7:0] instruction_memory[0:1023];

reg [0:79] instruction;

always @ (posedge clock)
begin
    mem_error = 0;
    if(pc_val > 1023)
    begin
        mem_error = 1;
    end

    icode = instruction_memory[pc_val][3:0];
    ifun = instruction_memory[pc_val][7:4];

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
    else if(icode==4'b0010) //cmovxx
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valP=pc_val+64'd2;
    end
    else if(icode==4'b0011) //irmovq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valC={instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8],instruction_memory[pc_val+9]};
      valP=pc_val+64'd10;
    end
    else if(icode==4'b0100) //rmmovq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valC={instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8],instruction_memory[pc_val+9]};
      valP=pc_val+64'd10;
    end
    else if(icode==4'b0101) //mrmovq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valC={instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8],instruction_memory[pc_val+9]};
      valP=pc_val+64'd10;
    end
    else if(icode==4'b0110) //OPq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valP=pc_val+64'd2;
    end
    else if(icode==4'b0111) //jxx
    begin
      valC={instruction_memory[pc_val+1],instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8]};
      valP=pc_val+64'd9;
    end
    else if(icode==4'b1000) //call
    begin
      valC={instruction_memory[pc_val+1],instruction_memory[pc_val+2],instruction_memory[pc_val+3],instruction_memory[pc_val+4],instruction_memory[pc_val+5],instruction_memory[pc_val+6],instruction_memory[pc_val+7],instruction_memory[pc_val+8]};
      valP=pc_val+64'd9;
    end
    else if(icode==4'b1001) //ret
    begin
      valP=pc_val+64'd1;
    end
    else if(icode==4'b1010) //pushq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valP=pc_val+64'd2;
    end
    else if(icode==4'b1011) //popq
    begin
      regA=instruction_memory[pc_val+1][3:0];
      regB=instruction_memory[pc_val+1][7:4];
      valP=pc_val+64'd2;
    end
    else 
    begin
      instruct_valid=1'b0;
    end
end
endmodule