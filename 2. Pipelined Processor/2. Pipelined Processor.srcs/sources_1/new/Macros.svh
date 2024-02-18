/////// Bus sizes definition
`define A_SIZE  10   // address size
`define D_SIZE  32   // data size
`define I_SIZE  16   // instruction size
`define M_SIZE  23   // mantissa size
`define E_SIZE  8    // exponent size
`define VAL     6
`define CONST   8
`define OFFSET  6


/////// GPRs definition
`define R0 3'd0
`define R1 3'd1
`define R2 3'd2
`define R3 3'd3
`define R4 3'd4
`define R5 3'd5
`define R6 3'd6
`define R7 3'd7


/////// The instruction set

/// Arithmetic and logic instructions
`define     NOP         7'b0000000
`define     ADD         7'b0000001
`define     ADDF        7'b0000010
`define     SUB         7'b0000011
`define     SUBF        7'b0000100
`define     AND         7'b0000101
`define     OR          7'b0000110
`define     XOR         7'b0000111
`define     NAND        7'b0001000
`define     NOR         7'b0001001
`define     NXOR        7'b0001010
`define     SHIFTR      7'b0001011   
`define     SHIFTRA     7'b0001100
`define     SHIFTL      7'b0001101

/// Data transfer instructions
`define     LOAD        5'b01000
`define     LOADC       5'b01001
`define     STORE       5'b01010

/// Branch instructions
`define     JMP         4'b1000
`define     JMPR        4'b1001
`define     JMPcond     4'b1010
`define     JMPRcond    4'b1011

/// Special instructions
`define     HALT        4'b1100


/////// Instruction operands

/// For Arithmetic and Logic
`define     op0     8 : 6
`define     op1     5 : 3
`define     op2     2 : 0
`define     val     5 : 0

/// For Data Transfers
`define     dt_op0  10 : 8
`define     dt_op1  2 : 0    
`define     const   7 : 0

/// For Branch Instructions
`define     offset  5 : 0
`define     br_op0  8 : 6
`define     br_op1  2 : 0

/// Flags
`define     cond    11 : 9
`define     N       3'b000          // Result is Negative
`define     NN      3'b001          // Result is Not Negative
`define     Z       3'b010          // Result is Zero
`define     NZ      3'b011          // Result is Not Zero