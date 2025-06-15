
`timescale 1ns / 1ps
`include "CLA17.v"

module CLA17_tb ();
// ---------- parameter ----------
localparam BIT      = 17;           // A, B bits
localparam SUM_BIT  = BIT + 1;      // result bits
localparam N_PAT_MAX = 1000;        
localparam LATENCY_CYC = 1;         

// ---------- DUT ----------
reg  clk;
reg  rstn;
reg  Cin;
reg  in_valid;
reg  [BIT-1:0]  A, B;

wire out_valid;
wire [SUM_BIT-1:0] result;

CLA17 uut (
    .clk      (clk),
    .rst_n    (rstn),
    .Cin      (Cin),
    .A        (A),
    .B        (B),
    .in_valid (in_valid),
    .out_valid(out_valid),
    .result   (result)
);

// ---------- clock generate ----------
initial begin
    clk = 0;
    forever #5 clk = ~clk;          // 100 MHz
end

// ---------- reset ----------
initial begin
    rstn = 0;
    repeat (2) @(posedge clk);
    rstn = 1;
end

// ---------- memory ----------
reg [BIT-1:0]      A_mem     [0:N_PAT_MAX-1];
reg [BIT-1:0]      B_mem     [0:N_PAT_MAX-1];
reg [SUM_BIT-1:0]  golden_res[0:N_PAT_MAX-1];
integer pat_cnt = 0;            

// ---------- file reading ----------
integer fd, r;
reg [BIT-1:0]  a_bin, b_bin, s_bin;
initial begin
    fd = $fopen("../py/golden.dat", "r");
    if (!fd) begin
        $display("❌ Error: Cannot open golden_bin.dat");
        $finish;
    end

    while (!$feof(fd)) begin
        // golden_bin.dat 每行：32b_A 32b_B 32b_sum
        r = $fscanf(fd, "%b %b %b\n", a_bin, b_bin, s_bin);
        if (r == 3) begin
            A_mem[pat_cnt]      = a_bin;
            B_mem[pat_cnt]      = b_bin;
            golden_res[pat_cnt] = s_bin;
            pat_cnt = pat_cnt + 1;
        end
        else begin
            $display("⚠️  Warning: illegal line at #%0d", pat_cnt);
        end
    end
    $fclose(fd);
    $display("✅ Loaded %0d test patterns from golden_bin.dat", pat_cnt);
end

// ---------- feed input ----------
integer j;
initial begin
    Cin      = 1'b0;
    in_valid = 1'b0;
    A        = 0;
    B        = 0;

    wait (rstn == 1);
    @(negedge clk);

    for (j = 0; j < pat_cnt; j = j + 1) begin
        in_valid <= 1'b1;
        A        <= A_mem[j];
        B        <= B_mem[j];
        @(negedge clk);       
    end

    in_valid <= 1'b0;
    A <= 0; B <= 0;
end

// ---------- timeout prevent ----------
integer timeout = 100000;
initial begin
    while (timeout > 0) begin
        @(posedge clk);
        timeout = timeout - 1;
    end
    $display($time, " Simulation Hang ....");
    $finish;
end

// ---------- check result ----------
integer k = 0;
integer errors = 0;
integer signed signed_sum;
localparam MASK_CARRY = 18'h1FFFF; //mask compare of carry bit
initial begin
    wait (rstn == 1);
    repeat (LATENCY_CYC) @(posedge clk);  

    while (k < pat_cnt) begin
        @(posedge clk);
        if (out_valid) begin              
            if ((result & MASK_CARRY) !== (golden_res[k] & MASK_CARRY)) begin
                $display("❌ [Mismatch] Pattern %0d:", k+1);
                $display("result   = %h", result);
                $display("expected = %h", golden_res[k]);
                errors = errors + 1;
            end
            else begin
                signed_sum = $signed(result[(BIT-1):0]);
                $display("✅ [Match] Pattern %0d: result = %h)(%0d)", k+1, result, signed_sum);
            end
            k = k + 1;
        end
    end

    $display("🎯 Test completed: %0d errors out of %0d patterns", errors, pat_cnt);
    if (errors == 0)
        $display("🎉 ALL PASS!");
    else
        $display("⚠️  Some mismatches found. Please check your design.");
    repeat (10) @(posedge clk);
    $finish;
end

// ---------- waveform dump ----------
initial begin
    $dumpfile("CLA17.vcd");
    $dumpvars(0, CLA17_tb);
end

endmodule
