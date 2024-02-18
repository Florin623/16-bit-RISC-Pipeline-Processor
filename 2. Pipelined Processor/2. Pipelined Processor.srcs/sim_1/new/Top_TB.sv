`include "Macros.svh"

`timescale 1ns / 1ps

module Top_TB();

    reg clk;
    reg rst;

    Top DUT(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    initial begin
        @(posedge clk);
        #0.3;
        rst = 1'b0;
        repeat(2) @(posedge clk);
        #0.3;
        rst = 1'b1;
        repeat(86) @(posedge clk);
        #0.3;
        rst = 1'b0;
        repeat(2) @(posedge clk);
        $finish;
    end

endmodule