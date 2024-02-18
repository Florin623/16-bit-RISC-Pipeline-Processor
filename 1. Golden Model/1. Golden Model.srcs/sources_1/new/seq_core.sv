`include "Macros.svh"

module seq_core(
    // general
    input		                        clk,
    input 		                        rst,       // active 0
    // program memory
    output reg signed [`A_SIZE - 1 : 0] pc,
    input             [15 : 0]          instruction,
    // data memory
    output reg 		                    read,      // active 1
    output reg 		                    write,     // active 1
    output reg        [`A_SIZE - 1 : 0] address,
    input             [`D_SIZE - 1 : 0] data_in,
    output reg        [`D_SIZE - 1 : 0] data_out
);

    reg signed [`D_SIZE - 1 : 0] R[0 : 7];
    integer i;

    always_comb begin
        read = 1'b0;
        write = 1'b0;
        address = 0;
        data_out = 0;
        case (instruction[`type])
            `arithmetic_logic: ;
            `data_transfer: begin
                case (instruction[`data_transfer_opcode])
                    `LOAD  : begin
                                 read = 1'b1;
                                 address = R[instruction[`dt_op1]];
                                 R[instruction[`dt_op0]] = data_in;
                    end
                    `LOADC : R[instruction[`dt_op0]] = {R[instruction[`dt_op0]][`D_SIZE - 1 : 8], instruction[`const]};
                    `STORE : begin
                                 write = 1'b1;
                                 address = R[instruction[`dt_op0]];
                                 data_out = R[instruction[`dt_op1]];
                    end
                    default: ;
                endcase
            end
            `branch: ;
            `special: ;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!rst) begin
            pc = 0;
            for (i = 0; i < 8; i = i + 1)
                R[i] = 0;
        end
        else begin
            case (instruction[`type])
                `arithmetic_logic: begin
                    case (instruction[`alu_opcode])
                        `NOP    : ;
                        `ADD    : R[instruction[`op0]] <= R[instruction[`op1]] + R[instruction[`op2]];
                        `ADDF   : R[instruction[`op0]] <= R[instruction[`op1]] + R[instruction[`op2]];
                        `SUB    : R[instruction[`op0]] <= R[instruction[`op1]] - R[instruction[`op2]];
                        `SUBF   : R[instruction[`op0]] <= R[instruction[`op1]] - R[instruction[`op2]];
                        `AND    : R[instruction[`op0]] <= R[instruction[`op1]] & R[instruction[`op2]];
                        `OR     : R[instruction[`op0]] <= R[instruction[`op1]] | R[instruction[`op2]];
                        `XOR    : R[instruction[`op0]] <= R[instruction[`op1]] ^ R[instruction[`op2]];
                        `NAND   : R[instruction[`op0]] <= ~(R[instruction[`op1]] & R[instruction[`op2]]);
                        `NOR    : R[instruction[`op0]] <= ~(R[instruction[`op1]] | R[instruction[`op2]]);
                        `NXOR   : R[instruction[`op0]] <= ~(R[instruction[`op1]] ^ R[instruction[`op2]]);
                        `SHIFTR : R[instruction[`op0]] <= R[instruction[`op0]] >> instruction[`val];
                        `SHIFTRA: R[instruction[`op0]] <= R[instruction[`op0]] >>> instruction[`val];
                        `SHIFTL : R[instruction[`op0]] <= R[instruction[`op0]] << instruction[`val];
                        default : ;
                    endcase
                    pc <= pc + 1;
                end
                `data_transfer: pc <= pc + 1;
                `branch: begin
                    case (instruction[`branch_opcode])
                        `JMP     : pc <= R[instruction[`br_op1]];
                        `JMPR    : pc <= pc + instruction[`offset];
                        `JMPcond : begin
                            case (instruction[`cond])
                                `N : begin
                                         if (R[instruction[`br_op0]][`D_SIZE - 1] == 1'b1)
                                             pc <= R[instruction[`br_op1]];
                                         else
                                             pc <= pc + 1;
                                end
                                `NN: begin
                                         if (R[instruction[`br_op0]][`D_SIZE - 1] == 1'b0)
                                             pc <= R[instruction[`br_op1]];
                                         else
                                             pc <= pc + 1;
                                end
                                `Z : begin
                                         if (R[instruction[`br_op0]] == 0)
                                             pc <= R[instruction[`br_op1]];
                                         else
                                             pc <= pc + 1;
                                end
                                `NZ: begin
                                         if (R[instruction[`br_op0]] != 0)
                                             pc <= R[instruction[`br_op1]];
                                         else
                                             pc <= pc + 1;
                                end
                                default: pc <= pc + 1;
                            endcase
                        end
                        `JMPRcond: begin
                            case (instruction[`cond])
                                `N : begin
                                         if (R[instruction[`br_op0]][`D_SIZE - 1] == 1'b1)
                                             pc <= pc + instruction[`offset];
                                         else
                                             pc <= pc + 1;
                                end
                                `NN: begin
                                         if (R[instruction[`br_op0]][`D_SIZE - 1] == 1'b0)
                                             pc <= pc + instruction[`offset];
                                         else
                                             pc <= pc + 1;
                                end
                                `Z : begin
                                         if (R[instruction[`br_op0]] == 0)
                                             pc <= pc + instruction[`offset];
                                         else
                                             pc <= pc + 1;
                                end
                                `NZ: begin
                                         if (R[instruction[`br_op0]] != 0)
                                             pc <= pc + instruction[`offset];
                                         else
                                             pc <= pc + 1;
                                end
                                default: pc <= pc + 1;
                            endcase
                        end
                        default: ;
                    endcase
                end
                `special: ;
            endcase
        end
    end

endmodule