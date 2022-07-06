//IPA Assignment 1
//VHDL Code for ADD Operation

//VHDL Code for half_adder
module half_adder(a,b,c,s);
input a,b;
output s,c;
xor (s,a,b);
and (c,a,b);
endmodule


//VHDL Code for full_adder
module full_adder(a,b,c_in,c_out,sum);
input a,b,c_in;
output sum,c_out;
wire s1,c1,c2;
half_adder h1 (a,b,c1,s1);
half_adder h2 (c_in,s1,c2,sum);
or (c_out,c1,c2);
endmodule


//VHDL Code for addition of two 64-bits number
module ADD(input1, input2, c_in, out, carry_out,overflow_check);
input signed [63:0] input1, input2;
input c_in; // c_in is 0 for addition
output signed [63:0] out;
output carry_out,overflow_check;
wire [63:0] carry;
genvar i;
generate
for(i=0;i<64;i=i+1)
begin: generate_ADD
if(i==0)
full_adder f(input1[0],input2[0],c_in,carry[0],out[0]);
else
full_adder f(input1[i],input2[i],carry[i-1],carry[i],out[i]);
end
assign carry_out = carry[63];
assign overflow_check = carry_out ^ carry[62];
endgenerate
endmodule