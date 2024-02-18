`include "Macros.svh"

module Processor(
    input                           clk,
    input                           rst,
    input         [`I_SIZE - 1 : 0] instruction,
    input  signed [`D_SIZE - 1 : 0] data_in,
    output                          read,
    output                          write,
    output signed [`A_SIZE - 1 : 0] pc,
    output        [`A_SIZE - 1 : 0] addr,
    output signed [`D_SIZE - 1 : 0] data_out
);

    wire                          load_flag;
    wire                          halt_flag;
    wire                          jmp_flag;
    wire                          jmpr_flag;
    wire                          valid_jmp;
    wire signed [`A_SIZE - 1 : 0] new_pc;
    wire        [`I_SIZE - 1 : 0] instruction_out_fetch;

    assign read = load_flag;

    FETCH fetch(
        .clk(clk),
        .rst(rst),
        .instruction_in(instruction),
        .load_flag(load_flag),
        .halt_flag(halt_flag),
        .jmp_flag(jmp_flag),
        .jmpr_flag(jmpr_flag),
        .valid_jmp(valid_jmp),
        .new_pc(new_pc),
        .pc(pc),
        .instruction_out(instruction_out_fetch)
    );

    wire [`I_SIZE - 1 : 0] instruction_out_ir;

    IR ir(
        .clk(clk),
        .rst(rst),
        .load_flag(load_flag),
        .halt_flag(halt_flag),
        .jmp_flag(jmp_flag),
        .jmpr_flag(jmpr_flag),
        .valid_jmp(valid_jmp),
        .instruction_in(instruction_out_fetch),
        .instruction_out(instruction_out_ir)
    );

    wire signed [`D_SIZE - 1 : 0] op0_data_regs;
    wire signed [`D_SIZE - 1 : 0] op1_data_regs;
    wire signed [`D_SIZE - 1 : 0] op2_data_regs;
    wire        [2 : 0]           dest_execute;
    wire signed [`D_SIZE - 1 : 0] result_execute;
    wire        [2 : 0]           dest;
    wire signed [`D_SIZE - 1 : 0] result;
    wire        [`I_SIZE - 1 : 0] instruction_out_read;
    wire        [2 : 0]           op0;
    wire        [2 : 0]           op1;
    wire        [2 : 0]           op2;
    wire signed [`D_SIZE - 1 : 0] op0_data_out;
    wire signed [`D_SIZE - 1 : 0] op1_data_out;
    wire signed [`D_SIZE - 1 : 0] op2_data_out;
    wire        [`VAL - 1 : 0]    val;
    wire signed [`CONST - 1 : 0]  cons;
    wire signed [`OFFSET - 1 : 0] offset;
    wire        [2 : 0]           cond;

    READ read_block(
        .instruction_in(instruction_out_ir),
        .op0_data_regs(op0_data_regs),
        .op1_data_regs(op1_data_regs),
        .op2_data_regs(op2_data_regs),
        .dest_execute(dest_execute),
        .result_execute(result_execute),
        .dest(dest),
        .result(result),
        .instruction_out(instruction_out_read),
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op0_data_out(op0_data_out),
        .op1_data_out(op1_data_out),
        .op2_data_out(op2_data_out),
        .val(val),
        .cons(cons),
        .offset(offset),
        .cond(cond)
    );

    REGS regs(
        .clk(clk),
        .rst(rst),
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .dest(dest),
        .result(result),
        .op0_data(op0_data_regs),
        .op1_data(op1_data_regs),
        .op2_data(op2_data_regs)
    );

    wire        [`I_SIZE - 1 : 0] instruction_out_read_pipeline;
    wire signed [`D_SIZE - 1 : 0] op0_data_out_read_pipeline;
    wire signed [`D_SIZE - 1 : 0] op1_data_out_read_pipeline;
    wire signed [`D_SIZE - 1 : 0] op2_data_out_read_pipeline;
    wire        [`VAL - 1 : 0]    val_out_read_pipeline;
    wire signed [`CONST - 1 : 0]  cons_out_read_pipeline;
    wire signed [`OFFSET - 1 : 0] offset_out_read_pipeline;
    wire        [2 : 0]           cond_out_read_pipeline;

    READ_Pipeline read_pipeline(
        .clk(clk),
        .rst(rst),
        .load_flag(load_flag),
        .halt_flag(halt_flag),
        .jmp_flag(jmp_flag),
        .jmpr_flag(jmpr_flag),
        .valid_jmp(valid_jmp),
        .instruction_in(instruction_out_read),
        .op0_data_in(op0_data_out),
        .op1_data_in(op1_data_out),
        .op2_data_in(op2_data_out),
        .val_in(val),
        .cons_in(cons),
        .offset_in(offset),
        .cond_in(cond),
        .instruction_out(instruction_out_read_pipeline),
        .op0_data_out(op0_data_out_read_pipeline),
        .op1_data_out(op1_data_out_read_pipeline),
        .op2_data_out(op2_data_out_read_pipeline),
        .val_out(val_out_read_pipeline),
        .cons_out(cons_out_read_pipeline),
        .offset_out(offset_out_read_pipeline),
        .cond_out(cond_out_read_pipeline)
    );

    wire [`I_SIZE - 1 : 0] instruction_out_execute;

    EXECUTE execute(
        .instruction_in(instruction_out_read_pipeline),
        .op0_data(op0_data_out_read_pipeline),
        .op1_data(op1_data_out_read_pipeline),
        .op2_data(op2_data_out_read_pipeline),
        .val(val_out_read_pipeline),
        .cons(cons_out_read_pipeline),
        .offset(offset_out_read_pipeline),
        .cond(cond_out_read_pipeline),
        .instruction_out(instruction_out_execute),
        .write(write),
        .load_flag(load_flag),
        .halt_flag(halt_flag),
        .jmp_flag(jmp_flag),
        .jmpr_flag(jmpr_flag),
        .valid_jmp(valid_jmp),
        .addr(addr),
        .data_out(data_out),
        .dest(dest_execute),
        .result(result_execute),
        .new_pc(new_pc)
    );

    wire        [`I_SIZE - 1 : 0] instruction_out_execute_pipeline;
    wire        [2 : 0]           dest_execute_pipeline;
    wire signed [`D_SIZE - 1 : 0] result_execute_pipeline;

    EXECUTE_Pipeline execute_pipeline(
        .clk(clk),
        .rst(rst),
        .halt_flag(halt_flag),
        .instruction_in(instruction_out_execute),
        .dest_in(dest_execute),
        .result_in(result_execute),
        .instruction_out(instruction_out_execute_pipeline),
        .dest_out(dest_execute_pipeline),
        .result_out(result_execute_pipeline)
    );

    WRITE_BACK write_back(
        .instruction_in(instruction_out_execute_pipeline),
        .dest_in(dest_execute_pipeline),
        .result_in(result_execute_pipeline),
        .data_in(data_in),
        .dest_out(dest),
        .result_out(result)
    );

endmodule