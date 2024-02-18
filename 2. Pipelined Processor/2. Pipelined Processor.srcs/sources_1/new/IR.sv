`include "Macros.svh"

module IR(
    input                        clk,
    input                        rst,
    input                        load_flag,
    input                        halt_flag,
    input                        jmp_flag,
    input                        jmpr_flag,
    input                        valid_jmp,
    input      [`I_SIZE - 1 : 0] instruction_in,
    output reg [`I_SIZE - 1 : 0] instruction_out
);

    always_ff @(posedge clk) begin
        if (!rst || (jmp_flag && valid_jmp) || (jmpr_flag && valid_jmp))
            instruction_out <= 0;
        else if (load_flag || halt_flag)
            instruction_out <= instruction_out;
        else
            instruction_out <= instruction_in;
    end

endmodule