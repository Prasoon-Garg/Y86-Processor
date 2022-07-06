module register_update(out, in, write_enable, reset, resetval, clock);
    parameter size = 64;
    output [size-1:0] out;
    reg [size-1:0] out;
    input [size-1:0] in;
    input write_enable;
    input reset;
    input [size-1:0] resetval;
    input clock;

    //positive egde of a clock.
    //The output may be updated to the either reset value or input if the clock is transitioned from 0 to 1 depending on the reset and enable.
    always @(posedge clock)
        begin
            if (reset)
                out <= resetval;  // Here Non-blocking assignment is used to avoid the blocking in the procedural flow.
            else if (write_enable)
                out <= in;
        end
endmodule