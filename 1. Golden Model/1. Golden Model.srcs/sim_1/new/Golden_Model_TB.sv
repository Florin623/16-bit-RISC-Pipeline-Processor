`include "Macros.svh"

module Golden_Model_TB();
	reg                    rst;
	reg                    clk;
	reg  [15 : 0]          instruction;
	wire [`D_SIZE - 1 : 0] data_in;
	wire [`D_SIZE - 1 : 0] data_out;
	wire [`A_SIZE - 1 : 0] address;
	wire [`A_SIZE - 1 : 0] pc;
	wire                   read;
	wire                   write;

    seq_core seq_core_DUT(
	    .clk(clk),
	    .rst(rst),
	    .instruction(instruction),
	    .data_in(data_in),
	    .data_out(data_out),
	    .address(address),
	    .pc(pc),
	    .read(read),
	    .write(write)
    );

    SRAM SRAM_DUT(
        .read(read),
        .write(write),
        .address(address),
        .data_in(data_out),
        .data_out(data_in)
    );

    initial begin
        forever #1 clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        repeat(2) @(posedge clk);
        rst = 1'b1;
        // testing the ALU Instructions
        instruction = {`LOADC, `R1, 8'd150};
        @(posedge clk)
        instruction = {`LOADC, `R2, 8'd100};
        @(posedge clk)
        instruction = {`ADD, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`ADDF, `R3, `R1, `R2};
        @(posedge clk)
        instruction = {`SUB, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`SUBF, `R3, `R1, `R2};
        @(posedge clk)
        instruction = {`AND, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`OR, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`XOR, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`NAND, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`NOR, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`NXOR, `R0, `R1, `R2};
        @(posedge clk)
        instruction = {`LOADC, `R3, 8'd128};
        @(posedge clk)
        instruction = {`SHIFTR, `R3, 6'd4};
        @(posedge clk)
        instruction = {`SHIFTL, `R3, 6'd28};
        @(posedge clk)
        instruction = {`SHIFTRA, `R3, 6'd8};
        @(posedge clk)
        instruction = {`NOP, 9'd0};

        @(posedge clk);
        rst = 1'b0;
        @(posedge clk);
        rst = 1'b1;
        // testing Data Transfer Instructions
        instruction = {`LOADC, `R4, 8'hAA};
        @(posedge clk)
        instruction = {`STORE, `R5, 5'd0, `R4};
        @(posedge clk)
        instruction = {`LOADC, `R0, 8'd1};
        @(posedge clk)
        instruction = {`STORE, `R0, 5'd0, `R4};               
        @(posedge clk)
        instruction = {`LOAD, `R6, 5'd0, `R0};
        @(posedge clk);
        instruction = {`ADD, `R1, `R0, `R4};

        @(posedge clk);
        rst = 1'b0;
        @(posedge clk);
        rst = 1'b1;
        // testing Branch Instructions
        instruction = {`LOADC, `R1, 8'hFF};
        @(posedge clk);
        instruction = {`SHIFTL, `R1, 6'd24};
        @(posedge clk);
        instruction = {`LOADC, `R2, 8'd47};
        @(posedge clk);
        instruction = {`LOADC, `R3, 8'd4};
        @(posedge clk);
        instruction = {`LOADC, `R4, 8'd10};
        @(posedge clk);
        instruction = {`LOADC, `R5, 8'd3};
        @(posedge clk);
        instruction = {`LOADC, `R6, 8'd6};
        @(posedge clk);
        instruction = {`LOADC, `R7, 8'd2};
        @(posedge clk);
        instruction = {`JMP, 9'd0, `R3};
        @(posedge clk);
        instruction = {`JMPR, 6'd0, 6'd2};

        @(posedge clk);
        instruction = {`JMPcond, `N, `R1, 3'b0, `R5};
        @(posedge clk);
        instruction = {`JMPcond, `N, `R2, 3'b0, `R5};
        @(posedge clk);

        instruction = {`JMPcond, `NN, `R2, 3'b0, `R4};
        @(posedge clk);
        instruction = {`JMPcond, `NN, `R1, 3'b0, `R4};
        @(posedge clk);

        instruction = {`JMPcond, `Z, `R0, 3'b0, `R6};
        @(posedge clk);
        instruction = {`JMPcond, `Z, `R1, 3'b0, `R6};
        @(posedge clk);

        instruction = {`JMPcond, `NZ, `R1, 3'b0, `R7};
        @(posedge clk);
        instruction = {`JMPcond, `NZ, `R0, 3'b0, `R7};                                                     
        @(posedge clk);

        instruction = {`JMPRcond, `N, `R1, 6'd18};
        @(posedge clk);
        instruction = {`JMPRcond, `N, `R2, 6'd7};
        @(posedge clk);

        instruction = {`JMPRcond, `NN, `R2, 6'd30};
        @(posedge clk);
        instruction = {`JMPRcond, `NN, `R1, 6'd1};
        @(posedge clk);

        instruction = {`JMPRcond, `Z, `R0, 6'd10};
        @(posedge clk);
        instruction = {`JMPRcond, `Z, `R2, 6'd3};
        @(posedge clk);

        instruction = {`JMPRcond, `NZ, `R2, 6'd25};
        @(posedge clk);
        instruction = {`JMPRcond, `NZ, `R0, 6'd12};
        @(posedge clk);
        // testing Special Instructions
        instruction = {`HALT, 12'd0};
        @(posedge clk);
        $finish;
    end

endmodule