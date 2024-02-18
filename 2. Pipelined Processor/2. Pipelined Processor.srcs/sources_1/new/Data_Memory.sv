`include "Macros.svh"

module Data_Memory(
    input                               clk,
    input                               read,
    input                               write,
    input             [`A_SIZE - 1 : 0] addr,
    input      signed [`D_SIZE - 1 : 0] data_in,
    output reg signed [`D_SIZE - 1 : 0] data_out
);

    reg signed [`D_SIZE - 1 : 0] memory [0 : 2**`A_SIZE - 1];

    always_ff @(posedge clk) begin
        if (read)
            data_out <= memory[addr];
        else if (write)
            memory[addr] <= data_in;
    end

endmodule