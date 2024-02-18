`include "Macros.svh"

module Top(
    input clk,
    input rst
);

    wire        [`I_SIZE - 1 : 0] instruction;
    wire signed [`D_SIZE - 1 : 0] data_in;
    wire                          read;
    wire                          write;
    wire        [`A_SIZE - 1 : 0] instr_addr;
    wire        [`A_SIZE - 1 : 0] data_addr;
    wire signed [`D_SIZE - 1 : 0] data_out;

    Processor processor(
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .data_in(data_in),
        .read(read),
        .write(write),
        .pc(instr_addr),
        .addr(data_addr),
        .data_out(data_out)
    );

    Program_Memory program_memory(
        .addr(instr_addr),
        .instruction(instruction)
    );

    Data_Memory data_memory(
        .clk(clk),    
        .read(read),   
        .write(write),  
        .addr(data_addr),   
        .data_in(data_out),
        .data_out(data_in)
    );

endmodule