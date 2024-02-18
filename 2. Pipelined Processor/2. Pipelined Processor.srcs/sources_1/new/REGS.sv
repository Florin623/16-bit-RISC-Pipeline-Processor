`include "Macros.svh"

module REGS(
    input                           clk,
    input                           rst,
    input         [2 : 0]           op0,
    input         [2 : 0]           op1,
    input         [2 : 0]           op2,
    input         [2 : 0]           dest,
    input  signed [`D_SIZE - 1 : 0] result,
    output signed [`D_SIZE - 1 : 0] op0_data,
    output signed [`D_SIZE - 1 : 0] op1_data,
    output signed [`D_SIZE - 1 : 0] op2_data
);

    reg signed [`D_SIZE - 1 : 0] R[0 : 7];
    integer i;

    always_ff @(posedge clk) begin
        if (!rst)
            for (i = 0; i < 8; i = i + 1)
                R[i] <= 0;
        else
            R[dest] <= result;
    end

    assign op0_data = R[op0];
    assign op1_data = R[op1];
    assign op2_data = R[op2];

endmodule