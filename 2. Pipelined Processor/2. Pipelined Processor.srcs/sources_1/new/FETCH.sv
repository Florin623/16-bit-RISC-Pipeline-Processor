`include "Macros.svh"

module FETCH(
    input                               clk,
    input                               rst,
    input             [`I_SIZE - 1 : 0] instruction_in,
    input                               load_flag,
    input                               halt_flag,
    input                               jmp_flag,
    input                               jmpr_flag,
    input                               valid_jmp,
    input      signed [`A_SIZE - 1 : 0] new_pc,
    output reg signed [`A_SIZE - 1 : 0] pc,
    output            [`I_SIZE - 1 : 0] instruction_out
);

    always_ff @(posedge clk) begin
        if (!rst)
            pc <= 0;
        else if (load_flag || halt_flag)
            pc <= pc;
        else if (jmp_flag && valid_jmp)
            pc <= new_pc;
        else if (jmpr_flag && valid_jmp)
            pc <= pc + new_pc;
        else
            pc <= pc + 1;
    end

    assign instruction_out = ((jmp_flag && valid_jmp) || (jmpr_flag && valid_jmp)) ? 0 : instruction_in;

endmodule