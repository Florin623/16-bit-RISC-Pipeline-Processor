`include "Macros.svh"

module EXECUTE(
    input             [`I_SIZE - 1 : 0] instruction_in,
    input      signed [`D_SIZE - 1 : 0] op0_data,
    input      signed [`D_SIZE - 1 : 0] op1_data,
    input      signed [`D_SIZE - 1 : 0] op2_data,
    input             [`VAL - 1 : 0]    val,
    input      signed [`CONST - 1 : 0]  cons,
    input      signed [`OFFSET - 1 : 0] offset,
    input             [2 : 0]           cond,
    output reg        [`I_SIZE - 1 : 0] instruction_out,
    output reg                          write,
    output reg                          load_flag,
    output reg                          halt_flag,
    output reg                          jmp_flag,
    output reg                          jmpr_flag,
    output reg                          valid_jmp,
    output reg        [`A_SIZE - 1 : 0] addr,
    output reg signed [`D_SIZE - 1 : 0] data_out,
    output reg        [2 : 0]           dest,
    output reg signed [`D_SIZE - 1 : 0] result,
    output reg signed [`A_SIZE - 1 : 0] new_pc
);

    always_comb begin
        instruction_out = instruction_in;
        write = 1'b0;
        addr = 0;
        data_out = 0;
        dest = 0;
        result = 0;
        load_flag = 1'b0;
        halt_flag = 1'b0;
        jmp_flag = 1'b0;
        jmpr_flag = 1'b0;
        valid_jmp = 1'b0;
        new_pc = 0;
        casez (instruction_in[`I_SIZE - 1 : 9])
            `NOP: ;
            `ADD, `ADDF: begin
                dest = instruction_in[`op0];
                result = op1_data + op2_data;
            end
            `SUB, `SUBF: begin
                dest = instruction_in[`op0];
                result = op1_data - op2_data;
            end
            `AND: begin
                dest = instruction_in[`op0];
                result = op1_data & op2_data;
            end
            `OR: begin
                dest = instruction_in[`op0];
                result = op1_data | op2_data;
            end
            `XOR: begin
                dest = instruction_in[`op0];
                result = op1_data ^ op2_data;
            end
            `NAND: begin
                dest = instruction_in[`op0];
                result = ~(op1_data & op2_data);
            end
            `NOR: begin
                dest = instruction_in[`op0];
                result = ~(op1_data | op2_data);
            end
            `NXOR: begin
                dest = instruction_in[`op0];
                result = ~(op1_data ^ op2_data);
            end
            `SHIFTR: begin
                dest = instruction_in[`op0];
                result = op0_data >> val;
            end
            `SHIFTRA: begin
                dest = instruction_in[`op0];
                result = op0_data >>> val;
            end
            `SHIFTL: begin
                dest = instruction_in[`op0];
                result = op0_data << val;
            end
            {`LOAD, 2'b??}: begin
                load_flag = 1'b1;
                dest = instruction_in[`dt_op0];
                addr = op1_data[`A_SIZE - 1 : 0];
            end
            {`LOADC, 2'b??}: begin
                dest = instruction_in[`dt_op0];
                result = {op0_data[`D_SIZE - 1 : 8], cons};
            end
            {`STORE, 2'b??}: begin
                write = 1'b1;
                addr = op0_data[`A_SIZE - 1 : 0];
                data_out = op1_data;
            end
            {`JMP, 3'b???}: begin
                jmp_flag = 1'b1;
                valid_jmp = 1'b1;
                new_pc = op0_data;
            end
            {`JMPR, 3'b???}: begin
                jmpr_flag = 1'b1;
                valid_jmp = 1'b1;
                new_pc = offset - 2;
            end
            {`JMPcond, 3'b???}: begin
                jmp_flag = 1'b1;
                case (cond)
                    `N : if (op0_data < 0) begin
                             valid_jmp = 1'b1;
					         new_pc = op1_data;
					     end
					     else
					         valid_jmp = 1'b0;
					`NN: if (op0_data >= 0) begin
                             valid_jmp = 1'b1;
					         new_pc = op1_data;
					     end
					     else
					         valid_jmp = 1'b0;
					`Z : if (op0_data == 0) begin
                             valid_jmp = 1'b1;
					         new_pc = op1_data;
					     end
					     else
					         valid_jmp = 1'b0;
					`NZ: if (op0_data != 0) begin
                             valid_jmp = 1'b1;
					         new_pc = op1_data;
					     end
					     else
					         valid_jmp = 1'b0;
                endcase
            end
            {`JMPRcond, 3'b???}: begin
                jmpr_flag = 1'b1;
                case (cond)
                    `N : if (op0_data < 0) begin
                             valid_jmp = 1'b1;
					         new_pc = offset - 2;
					     end
					     else
					         valid_jmp = 1'b0;
					`NN: if (op0_data >= 0) begin
                             valid_jmp = 1'b1;
					         new_pc = offset - 2;
					     end
					     else
					         valid_jmp = 1'b0;
					`Z : if (op0_data == 0) begin
                             valid_jmp = 1'b1;
					         new_pc = offset - 2;
					     end
					     else
					         valid_jmp = 1'b0;
					`NZ: if (op0_data != 0) begin
                             valid_jmp = 1'b1;
					         new_pc = offset - 2;
					     end
					     else
					         valid_jmp = 1'b0;
                endcase
            end
            {`HALT, 3'b???}: halt_flag = 1'b1;
            default: ;
        endcase
    end

endmodule