`include "Macros.svh"

module READ_Pipeline(
    input                               clk,
    input                               rst,
    input                               load_flag,
    input                               halt_flag,
    input                               jmp_flag,
    input                               jmpr_flag,
    input                               valid_jmp,
    input             [`I_SIZE - 1 : 0] instruction_in,
    input      signed [`D_SIZE - 1 : 0] op0_data_in,
    input      signed [`D_SIZE - 1 : 0] op1_data_in,
    input      signed [`D_SIZE - 1 : 0] op2_data_in,
    input             [`VAL - 1 : 0]    val_in,
    input      signed [`CONST - 1 : 0]  cons_in,
    input      signed [`OFFSET - 1 : 0] offset_in,
    input             [2 : 0]           cond_in,
    output reg        [`I_SIZE - 1 : 0] instruction_out,
    output reg signed [`D_SIZE - 1 : 0] op0_data_out,
    output reg signed [`D_SIZE - 1 : 0] op1_data_out,
    output reg signed [`D_SIZE - 1 : 0] op2_data_out,
    output reg        [`VAL - 1 : 0]    val_out,  
    output reg signed [`CONST - 1 : 0]  cons_out,
    output reg signed [`OFFSET - 1 : 0] offset_out,
    output reg        [2 : 0]           cond_out
);

    always_ff @(posedge clk) begin
        if (!rst || load_flag || (jmp_flag && valid_jmp) || (jmpr_flag && valid_jmp)) begin
            instruction_out <= 0;
            op0_data_out <= 0;
            op1_data_out <= 0;
            op2_data_out <= 0;
            val_out <= 0;
            cons_out <= 0;
            offset_out <= 0;
            cond_out <= 0;
        end
        else if (halt_flag) begin
            instruction_out <= instruction_out;
            op0_data_out <= op0_data_out;
            op1_data_out <= op1_data_out;
            op2_data_out <= op2_data_out;
            val_out <= val_out;
            cons_out <= cons_out;
            offset_out <= offset_out;
            cond_out  <= cond_out;
        end
        else begin
            instruction_out <= instruction_in;
            op0_data_out <= op0_data_in;
            op1_data_out <= op1_data_in;
            op2_data_out <= op2_data_in;
            val_out <= val_in;
            cons_out <= cons_in;
            offset_out <= offset_in;
            cond_out  <= cond_in;
        end
    end

endmodule