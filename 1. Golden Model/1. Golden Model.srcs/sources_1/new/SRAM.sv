`include "Macros.svh"

module SRAM(
    input                      read,
    input                      write,
    input      [`A_SIZE-1 : 0] address,
    input      [`D_SIZE-1 : 0] data_in,
    output reg [`D_SIZE-1 : 0] data_out
);

    reg [`D_SIZE-1 : 0] memory [0 : 2**`A_SIZE - 1];

    always_latch begin
        if (read)
            data_out <= memory[address];
        else if (write)
            memory[address] <= data_in;
    end

endmodule