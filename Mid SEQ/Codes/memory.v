module memory(icode,valA,valB,valP,valE,valM,clock);

input clock;
input [3:0] icode;
input [63:0] valA,valB,valP,valE;

output reg [63:0] valM;

reg [63:0] memory[0:1023]; // 1024 bytes of storage

always@(*) begin
    if(icode==4'b0100 || icode==4'b1010)
        memory[valE]=valA;
    else if(icode==4'b0101)
        valM = memory[valE];
    else if(icode==4'b1000)
        memory[valE] = valP;
    else if(icode==4'b1001)
        valM = memory[valA];
    else if(icode==4'b1011)
        valM=memory[valE];
end
endmodule