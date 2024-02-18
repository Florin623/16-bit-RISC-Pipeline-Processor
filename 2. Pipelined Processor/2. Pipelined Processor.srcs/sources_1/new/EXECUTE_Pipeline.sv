`include "Macros.svh"

module EXECUTE_Pipeline(
    input                               clk,
    input                               rst,
    input                               halt_flag,
    input             [`I_SIZE - 1 : 0] instruction_in,
    input             [2 : 0]           dest_in,
    input      signed [`D_SIZE - 1 : 0] result_in,
    output reg        [`I_SIZE - 1 : 0] instruction_out,
    output reg        [2 : 0]           dest_out,
    output reg signed [`D_SIZE - 1 : 0] result_out
);

    always_ff @(posedge clk) begin
        if (!rst) begin
            instruction_out <= 0;
            dest_out <= 0;
            result_out <= 0;
        end
        else if (halt_flag) begin
            instruction_out <= instruction_out;
            dest_out <= dest_out;
            result_out <= result_out;
        end
        else begin
            instruction_out[`I_SIZE - 1 : 9] <= instruction_in[`I_SIZE - 1 : 9];    // Otherwise the simulation wouldn't work, because
            instruction_out[8 : 0] <= 0;                                            // instruction_in[8 : 0] of WRITE_BACK wouldn't be connected to anything
            dest_out <= dest_in;
            result_out <= result_in;
        end
    end

endmodule