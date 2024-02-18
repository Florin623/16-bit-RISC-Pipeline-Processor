`include "Macros.svh"

module READ(
    input             [`I_SIZE - 1 : 0] instruction_in,
    input      signed [`D_SIZE - 1 : 0] op0_data_regs,
    input      signed [`D_SIZE - 1 : 0] op1_data_regs,
    input      signed [`D_SIZE - 1 : 0] op2_data_regs,
    input             [2 : 0]           dest_execute,
    input      signed [`D_SIZE - 1 : 0] result_execute,
    input             [2 : 0]           dest,
    input      signed [`D_SIZE - 1 : 0] result,
    output reg        [`I_SIZE - 1 : 0] instruction_out,
    output reg        [2 : 0]           op0,
    output reg        [2 : 0]           op1,
    output reg        [2 : 0]           op2,
    output reg signed [`D_SIZE - 1 : 0] op0_data_out,
    output reg signed [`D_SIZE - 1 : 0] op1_data_out,
    output reg signed [`D_SIZE - 1 : 0] op2_data_out,
    output reg        [`VAL - 1 : 0]    val,
    output reg signed [`CONST - 1 : 0]  cons,
    output reg signed [`OFFSET - 1 : 0] offset,
    output reg        [2 : 0]           cond
);

    always_comb begin
        instruction_out = instruction_in;
        op0 = 0;
        op1 = 0;
        op2 = 0;
        val = 0;
        cons = 0;
        offset = 0;
        cond = 0;
        casez (instruction_in[`I_SIZE - 1 : 9])
            `NOP, {`HALT, 3'b???}: ;
            `ADD, `ADDF, `SUB, `SUBF, `AND, `OR, `XOR, `NAND, `NOR, `NXOR: begin
                op0 = instruction_in[`op0];
                op1 = instruction_in[`op1];
                op2 = instruction_in[`op2];
            end
            `SHIFTR, `SHIFTRA, `SHIFTL: begin
                op0 = instruction_in[`op0];
                val = instruction_in[`val];
            end
            {`LOAD, 2'b??}, {`STORE, 2'b??}: begin
                op0 = instruction_in[`dt_op0];
                op1 = instruction_in[`dt_op1];
            end
            {`LOADC, 2'b??}: begin
                op0 = instruction_in[`dt_op0];
                cons = instruction_in[`const];
            end
            {`JMP, 3'b???}: op0 = instruction_in[`br_op1];
            {`JMPR, 3'b???}: offset = instruction_in[`offset];
            {`JMPcond, 3'b???}: begin
                cond = instruction_in[`cond];
                op0 = instruction_in[`br_op0];
                op1 = instruction_in[`br_op1];
            end
            {`JMPRcond, 3'b???}: begin
                cond = instruction_in[`cond];
                op0 = instruction_in[`br_op0];
                offset = instruction_in[`offset];
            end
            default: ;
        endcase

        if (instruction_in[15 : 9] != `NOP && op0 == dest_execute)
            op0_data_out = result_execute;
        else if (instruction_in[15 : 9] != `NOP && op0 == dest)
            op0_data_out = result;
        else
            op0_data_out = op0_data_regs;

        if (instruction_in[15 : 9] != `NOP && op1 == dest_execute)
            op1_data_out = result_execute;
        else if (instruction_in[15 : 9] != `NOP && op1 == dest)
            op1_data_out = result;
        else
            op1_data_out = op1_data_regs;

        if (instruction_in[15 : 9] != `NOP && op2 == dest_execute)
            op2_data_out = result_execute;
        else if (instruction_in[15 : 9] != `NOP && op2 == dest)
            op2_data_out = result;
        else
            op2_data_out = op2_data_regs;
    end

endmodule