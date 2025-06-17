`timescale 1ns/1ps
`define CLK_PER 10               // 100 MHz  (10 ns)

`include "mont_add.v"          


module tb_mont_add;

reg clk = 0;
always #(`CLK_PER/2) clk = ~clk;

reg rst_n;

parameter PAT = 20;            
reg [15:0] memA   [0:PAT-1];
reg [15:0] memB   [0:PAT-1];
reg [15:0] golden [0:PAT-1];

initial begin
    $readmemh("./py/A16.dat"    , memA);
    $readmemh("./py/B16.dat"    , memB);
    $readmemh("./py/golden16.dat", golden);
end

reg  [15:0] in_A, in_B;
reg         in_valid;
wire [15:0] result;
wire        out_valid;

mont_add dut (
    .in_A(in_A),
    .in_B(in_B),
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .result(result),
    .out_valid(out_valid)
);

integer i;
initial begin

    $dumpfile("mont_add_tb.vcd");
    $dumpvars(0, tb_mont_add);

    rst_n    = 0;
    in_valid = 0;
    in_A     = 0;
    in_B     = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);

    for (i = 0; i < PAT; i = i + 1) begin
        @(posedge clk);
        in_A     <= memA[i];
        in_B     <= memB[i];
        in_valid <= 1'b1;         
    end
end

integer j = 0;
integer err = 0;

initial begin
    wait(rst_n);           
    wait(out_valid);      
    @(negedge clk);       

    for (j = 0; j < PAT; j = j + 1) begin
        if (result === golden[j]) begin
            $display("[PASS] pat=%0d  exp=%04h  got=%04h",
                     j, golden[j], result);
        end else begin
            $display("[FAIL] pat=%0d  exp=%04h  got=%04h",
                     j, golden[j], result);
            err = err + 1;
        end
        @(negedge clk);   
    end

    if (err == 0)
        $display("=========== ALL %0d PATTERN PASS ===========", PAT);
    else
        $display("**** %0d mismatches out of %0d ****", err, PAT);

    repeat (20) @(posedge clk);
    $finish;
end

endmodule
