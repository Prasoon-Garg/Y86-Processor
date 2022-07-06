//VHDL code for 1's complement
module complement_1(in,out);
input [63:0] in;
output [63:0] out;
genvar i;
generate
for(i=0;i<64;i=i+1)
begin: generate_complement_1
not G(out[i],in[i]);
end
endgenerate
endmodule

// Subtraction module
    
module SUB(input1, input2, out, carry_out,overflow_check);
input signed [63:0] input1, input2;
output signed [63:0] out;
output carry_out,overflow_check;
wire signed [63:0] input2_cmpmt;
reg c_in = 1;
complement_1 G1(input2,input2_cmpmt);
ADD G2(input1,input2_cmpmt,c_in,out,carry_out,overflow_check);
endmodule