`include "Macros.svh"

module WRITE_BACK(
    input             [`I_SIZE - 1 : 0] instruction_in,
    input             [2 : 0]           dest_in,
    input      signed [`D_SIZE - 1 : 0] result_in,
    input      signed [`D_SIZE - 1 : 0] data_in,
    output reg        [2 : 0]           dest_out,
    output reg signed [`D_SIZE - 1 : 0] result_out
);

    always_comb begin
        dest_out = 0;
        result_out = 0;
        casez (instruction_in[`I_SIZE - 1 : 9])
            `ADD, `ADDF, `SUB, `SUBF, `AND, `OR, `XOR, `NAND, `NOR,
            `NXOR, `SHIFTR, `SHIFTRA, `SHIFTL, {`LOADC, 2'b??}: begin
                dest_out = dest_in;
                result_out = result_in;
            end 
            {`LOAD, 2'b??}: begin
                dest_out = dest_in;
                result_out = data_in;
            end
            default: ;
        endcase
    end

endmodule