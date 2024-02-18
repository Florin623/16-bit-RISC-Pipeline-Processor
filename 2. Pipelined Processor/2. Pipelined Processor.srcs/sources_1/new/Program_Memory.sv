`include "Macros.svh"

module Program_Memory(
    input  [`A_SIZE - 1 : 0] addr,
    output [`I_SIZE - 1 : 0] instruction
);

    reg signed [`I_SIZE - 1 : 0] memory [0 : 2**`A_SIZE - 1];

    assign instruction = memory[addr];

    initial begin
        memory[00] = {`NOP, 9'b0};
        memory[01] = {`LOADC, `R1, 8'd150};
        memory[02] = {`LOADC, `R2, 8'd100};
        memory[03] = {`ADD, `R0, `R1, `R2};
        memory[04] = {`ADDF, `R3, `R1, `R0};
        memory[05] = {`SUB, `R4, `R3, `R2};
        memory[06] = {`SUBF, `R4, `R4, `R3};
        memory[07] = {`AND, `R1, `R2, `R3};
        memory[08] = {`OR, `R2, `R3, `R4};
        memory[09] = {`NAND, `R3, `R4, `R5};
        memory[10] = {`XOR, `R4, `R0, `R3};
        memory[11] = {`NOR, `R5, `R4, `R4};
        memory[12] = {`NXOR, `R6, `R5, `R0};
        memory[13] = {`SHIFTR, `R0, 6'd5};
        memory[14] = {`LOADC, `R7, 8'd128};
        memory[15] = {`SHIFTL, `R7, 6'd24};
        memory[16] = {`SHIFTRA, `R7, 6'd5};
        memory[17] = {`LOADC, `R0, 8'd15};
        memory[18] = {`LOADC, `R1, 8'd1};
        memory[19] = {`STORE, `R0, 5'd0, `R2};
        memory[20] = {`JMPR, 6'd0, 6'd5};
        memory[21] = {`LOADC, `R7, 8'd128};
        memory[22] = {`SHIFTL, `R7, 6'd24};
        memory[23] = {`SHIFTRA, `R7, 6'd5};
        memory[24] = {`AND, `R1, `R2, `R6};
        memory[25] = {`OR, `R7, `R5, `R4};
        memory[26] = {`LOADC, `R0, 8'd15};
        memory[27] = {`LOAD, `R3, 5'd0, `R0};
        memory[28] = {`SUBF, `R1, `R2, `R3};
        memory[29] = {`SUB, `R6, `R6, `R6};
        memory[30] = {`LOADC, `R6, 8'd82};
        memory[31] = {`SHIFTR, `R3, 6'd25};
        memory[32] = {`SHIFTR, `R2, 6'd26};
        memory[33] = {`LOADC, `R1, 8'd45};
        memory[34] = {`JMP, 9'd0, `R1};
        memory[35] = {`LOADC, `R4, 8'd20};
        memory[45] = {`SHIFTL, `R4, 6'd4};
        memory[46] = {`JMPcond, `N, `R4, 3'b0, `R2};
        memory[63] = {`XOR, `R7, `R7, `R6};
        memory[64] = {`JMPcond, `N, `R1, 3'b0, `R5};
        memory[65] = {`NAND, `R1, `R2, `R7};
        memory[66] = {`JMPcond, `NN, `R6, 3'b0, `R6};
        memory[82] = {`SHIFTRA, `R2, 6'd5};
        memory[83] = {`JMPcond, `NN, `R7, 3'b0, `R0};
        memory[84] = {`STORE, `R2, 5'd0, `R2};
        memory[85] = {`JMPcond, `Z, `R0, 3'b0, `R3};
        memory[127] = {`LOAD, `R4, 5'd0, `R2};
        memory[128] = {`JMPcond, `Z, `R2, 3'b0, `R7};
        memory[129] = {`JMPcond, `NZ, `R5, 3'b0, `R5};
        memory[250] = {`SUBF, `R2, `R3, `R7};
        memory[251] = {`JMPcond, `NZ, `R0, 3'b0, `R1};
        memory[252] = {`ADDF, `R6, `R7, `R5};
        memory[253] = {`JMPRcond, `N, `R1, 6'd27};
        memory[280] = {`OR, `R5, `R0, `R7};
        memory[281] = {`JMPRcond, `N, `R0, 6'd63};
        memory[282] = {`SHIFTR, `R7, 6'd12};
        memory[283] = {`JMPRcond, `NN, `R2, 6'd31};
        memory[314] = {`AND, `R4, `R5, `R6};
        memory[315] = {`JMPRcond, `NN, `R5, 6'd2};
        memory[316] = {`JMPRcond, `Z, `R0, 6'd17};
        memory[333] = {`NOR, `R3, `R2, `R1};
        memory[334] = {`JMPRcond, `Z, `R3, 6'd6};
        memory[335] = {`NXOR, `R7, `R6, `R4};
        memory[336] = {`JMPRcond, `NZ, `R6, 6'd24};
        memory[360] = {`LOADC, `R2, 8'd21};
        memory[361] = {`JMPRcond, `NZ, `R0, 6'd49};
        memory[362] = {`HALT, 12'b0};
    end

endmodule