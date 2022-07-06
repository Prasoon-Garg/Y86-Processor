//IPA Assignment 1
//VHDL Code for XOR Operation

module XOR(input1,input2,out);
input [63:0] input1,input2;
output [63:0] out;
genvar i;
generate
for(i=0;i<64;i=i+1)
begin: generate_AND
xor G(out[i],input1[i],input2[i]);
end
endgenerate
endmodule