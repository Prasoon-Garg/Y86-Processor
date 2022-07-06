module alu(control,input1,input2,alu_out,alu_carry_out,alu_overflow_check);
    input signed [63:0] input1,input2;
    input [1:0] control;
    output signed [63:0] alu_out;
    output alu_carry_out,alu_overflow_check;
    reg signed [63:0] out;
    reg carry_out,overflow_check;
    reg c_in = 0;
    wire [63:0] carry;
    wire signed [63:0] add_out,sub_out,and_out,xor_out;
    output add_carry_out,add_overflow_check,sub_carry_out,sub_overflow_check;
    ADD G1(input1, input2, c_in, add_out, add_carry_out, add_overflow_check);
    SUB G2(input1, input2, sub_out, sub_carry_out,sub_overflow_check);
    AND G3(input1,input2,and_out);
    XOR G4(input1,input2,xor_out);
    always @(*) begin
    case(control)
        0: begin
            out = add_out;
            carry_out = add_carry_out;
            overflow_check = add_overflow_check;
        end
        1: begin
            out = sub_out;
            carry_out = sub_carry_out;
            overflow_check = sub_overflow_check;
        end
        2: begin
            out = and_out;
            carry_out = 0;
            overflow_check = 0;
        end
        3: begin
            out = xor_out;
            carry_out = 0;
            overflow_check = 0;
        end
    endcase
    end
    assign alu_out = out;
    assign alu_carry_out = carry_out;
    assign alu_overflow_check = overflow_check;
endmodule