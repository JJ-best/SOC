`timescale 1ns / 1ps
`define CYCLE     10         	       // Modify your clock period here
`define SDFFILE   "../syn/netlist/fir_syn.sdf"      // Modify your sdf file name
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2023 10:38:55 AM
// Design Name: 
// Module Name: fir_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define Data_Num0 350
`define Data_Num1 600
`define Data_Num2 300
`define Data_Num3 400
`define Coef_Num0 32
`define Coef_Num1 32
`define Coef_Num2 16
`define Coef_Num3 20

module fir_tb
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32
)();
    wire                        awready;
    wire                        wready;
    reg                         awvalid;
    reg   [(pADDR_WIDTH-1): 0]  awaddr;
    reg                         wvalid;
    reg signed [(pDATA_WIDTH-1) : 0] wdata;
    wire                        arready;
    reg                         rready;
    reg                         arvalid;
    reg         [(pADDR_WIDTH-1): 0] araddr;
    wire                        rvalid;
    wire signed [(pDATA_WIDTH-1): 0] rdata;
    reg                         ss_tvalid;
    reg signed [(pDATA_WIDTH-1) : 0] ss_tdata;
    reg                         ss_tlast;
    wire                        ss_tready;
    reg                         sm_tready;
    wire                        sm_tvalid;
    wire signed [(pDATA_WIDTH-1) : 0] sm_tdata;
    wire                        sm_tlast;
    reg                         axis_clk;
    reg                         axis_rst_n;

// ram for tap
    wire [3:0]               tap_WE;
    wire                     tap_EN;
    wire [(pDATA_WIDTH-1):0] tap_Di;
    wire [(pADDR_WIDTH-1):0] tap_A;
    wire [(pDATA_WIDTH-1):0] tap_Do;

// ram for data RAM
    wire [3:0]               data_WE;
    wire                     data_EN;
    wire [(pDATA_WIDTH-1):0] data_Di;
    wire [(pADDR_WIDTH-1):0] data_A;
    wire [(pDATA_WIDTH-1):0] data_Do;



    fir fir_DUT(
        .awready(awready),
        .wready(wready),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .arready(arready),
        .rready(rready),
        .arvalid(arvalid),
        .araddr(araddr),
        .rvalid(rvalid),
        .rdata(rdata),
        .ss_tvalid(ss_tvalid),
        .ss_tdata(ss_tdata),
        .ss_tlast(ss_tlast),
        .ss_tready(ss_tready),
        .sm_tready(sm_tready),
        .sm_tvalid(sm_tvalid),
        .sm_tdata(sm_tdata),
        .sm_tlast(sm_tlast),

        // ram for tap
        .tap_WE(tap_WE),
        .tap_EN(tap_EN),
        .tap_Di(tap_Di),
        .tap_A(tap_A),
        .tap_Do(tap_Do),

        // ram for data
        .data_WE(data_WE),
        .data_EN(data_EN),
        .data_Di(data_Di),
        .data_A(data_A),
        .data_Do(data_Do),

        .axis_clk(axis_clk),
        .axis_rst_n(axis_rst_n)

        );
    
    // RAM for tap
    bram32 tap_RAM (
        .CLK(axis_clk),
        .WE(tap_WE),
        .EN(tap_EN),
        .Di(tap_Di),
        .A(tap_A),
        .Do(tap_Do)
    );

    // RAM for data: choose bram11 or bram12
    bram32 data_RAM(
        .CLK(axis_clk),
        .WE(data_WE),
        .EN(data_EN),
        .Di(data_Di),
        .A(data_A),
        .Do(data_Do)
    );
`ifdef SDF
   initial $sdf_annotate(`SDFFILE, fir_DUT);
`endif
    reg signed [(pDATA_WIDTH-1):0] Din_list0[0:(`Data_Num0-1)];
    reg signed [(pDATA_WIDTH-1):0] golden_list0[0:(`Data_Num0-1)];
    reg signed [(pDATA_WIDTH-1):0] coef0[0:(`Coef_Num0-1)]; // fill in coef 

    reg signed [(pDATA_WIDTH-1):0] Din_list1[0:(`Data_Num1-1)];
    reg signed [(pDATA_WIDTH-1):0] golden_list1[0:(`Data_Num1-1)];
    reg signed [(pDATA_WIDTH-1):0] coef1[0:(`Coef_Num1-1)]; // fill in coef 

    reg signed [(pDATA_WIDTH-1):0] Din_list2[0:(`Data_Num2-1)];
    reg signed [(pDATA_WIDTH-1):0] golden_list2[0:(`Data_Num2-1)];
    reg signed [(pDATA_WIDTH-1):0] coef2[0:(`Coef_Num2-1)]; // fill in coef 

    reg signed [(pDATA_WIDTH-1):0] Din_list3[0:(`Data_Num3-1)];
    reg signed [(pDATA_WIDTH-1):0] golden_list3[0:(`Data_Num3-1)];
    reg signed [(pDATA_WIDTH-1):0] coef3[0:(`Coef_Num3-1)]; // fill in coef 
    `ifdef FSDB
        initial begin
            $fsdbDumpfile("fir.fsdb");
            $fsdbDumpvars("+mda");
        end
    `elsif
        initial begin
            $dumpfile("fir.vcd");
            $dumpvars();
        end
    `endif

    initial begin
        axis_clk = 0;
        forever begin
            #5 axis_clk = (~axis_clk);
        end
    end

    initial begin
        axis_rst_n = 0;
        @(posedge axis_clk); 
        @(posedge axis_clk);
        axis_rst_n = 1;
    end

    reg [31:0] data_length0, data_length1, data_length2, data_length3;
    reg [31:0] coef_length0, coef_length1, coef_length2, coef_length3;
    reg stop;
    integer Din0, Din1, Din2, Din3;
    integer golden0, golden1, golden2, golden3;
    integer coef_in, input_data, golden_data, m, n;
    integer coef_data0, coef_data1, coef_data2, coef_data3;

    reg error_coef;
    integer k,l;
    reg error;
    reg status_error;
    initial begin
        data_length0 = 0;
        data_length1 = 0;
        data_length2 = 0;
        data_length3 = 0;

        coef_length0 = 0;
        coef_length1 = 0;
        coef_length2 = 0;
        coef_length3 = 0;

        Din0 = $fopen("../py0/x.dat","r");
        golden0 = $fopen("../py0/y.dat","r");
	    coef_data0 = $fopen("../py0/coef.dat","r");

        Din1 = $fopen("../py1/x.dat","r");
        golden1 = $fopen("../py1/y.dat","r");
	    coef_data1 = $fopen("../py1/coef.dat","r");

        Din2 = $fopen("../py2/x.dat","r");
        golden2 = $fopen("../py2/y.dat","r");
	    coef_data2 = $fopen("../py2/coef.dat","r");

        Din3 = $fopen("../py3/x.dat","r");
        golden3 = $fopen("../py3/y.dat","r");
	    coef_data3 = $fopen("../py3/coef.dat","r");

        for(m=0;m< `Data_Num0 ;m=m+1) begin
            input_data = $fscanf(Din0,"%d", Din_list0[m]);
            golden_data = $fscanf(golden0,"%d", golden_list0[m]);
            data_length0 = data_length0 + 1;
        end
        for(n=0;n< `Coef_Num0 ;n=n+1)  begin 
            coef_in=$fscanf(coef_data0,"%d", coef0[n]);
            coef_length0 = coef_length0 + 1;
        end

        for(m=0;m< `Data_Num1 ;m=m+1) begin
            input_data = $fscanf(Din1,"%d", Din_list1[m]);
            golden_data = $fscanf(golden1,"%d", golden_list1[m]);
            data_length1 = data_length1 + 1;
        end
        for(n=0;n< `Coef_Num1 ;n=n+1)  begin 
            coef_in=$fscanf(coef_data1,"%d", coef1[n]);
            coef_length1 = coef_length1 + 1;
        end

        for(m=0;m< `Data_Num2 ;m=m+1) begin
            input_data = $fscanf(Din2,"%d", Din_list2[m]);
            golden_data = $fscanf(golden2,"%d", golden_list2[m]);
            data_length2 = data_length2 + 1;
        end
        for(n=0;n< `Coef_Num2 ;n=n+1)  begin 
            coef_in=$fscanf(coef_data2,"%d", coef2[n]);
            coef_length2 = coef_length2 + 1;
        end

        for(m=0;m< `Data_Num3 ;m=m+1) begin
            input_data = $fscanf(Din3,"%d", Din_list3[m]);
            golden_data = $fscanf(golden3,"%d", golden_list3[m]);
            data_length3 = data_length3 + 1;
        end
        for(n=0;n< `Coef_Num3 ;n=n+1)  begin 
            coef_in=$fscanf(coef_data3,"%d", coef3[n]);
            coef_length3 = coef_length3 + 1;
        end
    end

//-----AXI Lite: write coefficient-----//
    initial begin
        arvalid=0;
        rready=0;
        error_coef = 0;
        $display("----Start the coefficient input(AXI-lite): ROUND1----");
        config_write0(12'h10, data_length0);
        config_write0(12'h14, coef_length0);
        for(k=0; k< `Coef_Num0; k=k+1) begin
            config_write0(12'h80+4*k, coef0[k]);
            config_read_check0(12'h80+4*k, coef0[k], 32'hFFFF_FFFF);
            config_read_check0(12'h00, 32'h4, 32'h0000_0004); //check ap_idle == 1
            config_read_check0(12'h00, 32'h0, 32'h0000_0002); //check ap_done == 0
        end
        awvalid <= 0; wvalid <= 0;
        // read-back and check
        $display(" Check Coefficient ...");
        arvalid <= 0;
        $display(" Tape programming done ...");
        $display(" Start FIR");
        @(posedge axis_clk) config_write0(12'h00, 32'h0000_0001);// ap_start = 1
        $display("----End the coefficient input(AXI-lite)----");
        //$finish;
        wait(stop);
//-----ROUND2-----//
        $display("----Start the coefficient input(AXI-lite): ROUND2----");
        config_write1(12'h10, data_length1);
        config_write1(12'h14, coef_length1);
        //no need to write tap
        awvalid <= 0; wvalid <= 0;
        arvalid <= 0;
        // read-back and check
        $display(" Check Coefficient ...");
        $display(" Tape programming done ...");
        $display(" Start FIR");
        @(posedge axis_clk) config_write1(12'h00, 32'h0000_0001);// ap_start = 1
        $display("----End the coefficient input(AXI-lite)----");
        //$finish;
        wait(stop);
//-----ROUND3-----//
       $display("----Start the coefficient input(AXI-lite): ROUND3----");
        config_write1(12'h10, data_length2);
        config_write1(12'h14, coef_length2);
        for(k=0; k< `Coef_Num2; k=k+1) begin
            config_write1(12'h80+4*k, coef2[k]);
            config_read_check1(12'h80+4*k, coef2[k], 32'hFFFF_FFFF);
            config_read_check1(12'h00, 32'h4, 32'h0000_0004); //check ap_idle == 1
            config_read_check1(12'h00, 32'h0, 32'h0000_0002); //check ap_done == 0
        end
        awvalid <= 0; wvalid <= 0;
        // read-back and check
        $display(" Check Coefficient ...");
        arvalid <= 0;
        $display(" Tape programming done ...");
        $display(" Start FIR");
        @(posedge axis_clk) config_write2(12'h00, 32'h0000_0001);// ap_start = 1
        $display("----End the coefficient input(AXI-lite)----");
        //$finish;

    end

//-----AXI Stream: input data-----//
    integer i;
    initial begin
//-----ROUND1-----//
        $display("------------Start simulation: ROUND1-----------");
        ss_tvalid = 0;
        ss_tlast = 0; 
        ss_tdata = 0;
        $display("----Start the data input(AXI-Stream)----");
        for(i=0;i<(data_length0-1);i=i+1) begin
            axi_stream_master0(Din_list0[i]);
        end
        ss_tvalid = 0; //not here origin
	    config_read_check0(12'h00, 32'h00, 32'h0000_0002); // check done= 0
        ss_tlast = 1; 
        axi_stream_master0(Din_list0[(`Data_Num0 - 1)]);
        ss_tlast = 0; 
        $display("------End the data input(AXI-Stream): ROUND1------");
        wait(stop);

//-----ROUND2-----//
        $display("------------Start simulation: ROUND2-----------");
        ss_tvalid = 0;
        ss_tlast = 0; 
        ss_tdata = 0;
        $display("----Start the data input(AXI-Stream)----");
        for(i=0;i<(data_length1-1);i=i+1) begin
            axi_stream_master1(Din_list1[i]);
            // config_read_check1(12'h10, data_length1, 32'hFFFF_FFFF);
            // config_read_check1(12'h14, coef_length1, 32'hFFFF_FFFF);
            // config_read_check1(12'h00, 32'h01, 32'h0000_0001); // check ap_start = 1;
            // config_read_check1(12'h00, 32'h00, 32'h0000_0004); // check ap_idle = 0 (0x00 [bit 2])
            // config_read_check1(12'h00, 32'h00, 32'h0000_0002); // check done= 0
            // config_read_check1(12'h84, 32'hFFFF_FFFF, 32'hFFFF_FFFF); // check if read tap returns ffffffff
        end
        config_read_check1(12'h00, 32'h00, 32'h0000_0002); // check idle = 0
        ss_tlast = 1; 
        axi_stream_master1(Din_list1[(`Data_Num1 - 1)]);
        ss_tlast = 0;
        $display("------End the data input(AXI-Stream): ROUND2------");
        wait(stop);
//-----ROUND3-----//
        $display("------------Start simulation: ROUND3-----------");
        ss_tvalid = 0;
        ss_tlast = 0; 
        ss_tdata = 0;
        $display("----Start the data input(AXI-Stream)----");
        for(i=0;i<(data_length1-1);i=i+1) begin
            axi_stream_master1(Din_list1[i]);
            // config_read_check2(12'h10, data_length1, 32'hFFFF_FFFF);
            // config_read_check2(12'h14, coef_length1, 32'hFFFF_FFFF);
            // config_read_check2(12'h00, 32'h01, 32'h0000_0001); // check ap_start = 1;
            // config_read_check2(12'h00, 32'h00, 32'h0000_0004); // check ap_idle = 0 (0x00 [bit 2])
            // config_read_check2(12'h00, 32'h00, 32'h0000_0002); // check done= 0
            // config_read_check2(12'h84, 32'hFFFF_FFFF, 32'hFFFF_FFFF); // check if read tap returns ffffffff
        end
        config_read_check2(12'h00, 32'h00, 32'h0000_0002); // check idle = 0
        ss_tlast = 1; 
        axi_stream_master1(Din_list2[(`Data_Num2 - 1)]);
        ss_tlast = 0;
        $display("------End the data input(AXI-Stream): ROUND3------");
    end


//-----AXI Stream output result-----//

    initial begin
        wait(axis_rst_n==0);
        wait(axis_rst_n==1);
        stop = 0;
        error = 0; status_error = 0;
//-----ROUND1-----//
        sm_tready = 0;
        for(l=0;l < data_length0; l=l+1) begin
            $display("golden_value: %d", l);
            sm0(golden_list0[l],l);
        end
        config_read_check0(12'h00, 32'h02, 32'h0000_0002); // check ap_done = 1 (0x00 [bit 1])
        config_read_check0(12'h00, 32'h04, 32'h0000_0004); // check ap_idle = 1 (0x00 [bit 2])
        stop <= 1;
        @(posedge axis_clk);
        stop <= 0;
//-----ROUND2-----//
        sm_tready = 0;
        for(l=0;l < data_length1; l=l+1) begin
            $display("golden_value: %d", l);
            sm1(golden_list1[l],l);
        end
        config_read_check1(12'h00, 32'h02, 32'h0000_0002); // check ap_done = 1 (0x00 [bit 1])
        config_read_check1(12'h00, 32'h04, 32'h0000_0004); // check ap_idle = 1 (0x00 [bit 2])
        stop <= 1;
        @(posedge axis_clk);
        stop <= 0;
//-----ROUND3-----//
        sm_tready = 0;
        for(l=0;l < data_length2; l=l+1) begin
            $display("golden_value: %d", l);
            sm1(golden_list2[l],l);
        end
        config_read_check1(12'h00, 32'h02, 32'h0000_0002); // check ap_done = 1 (0x00 [bit 1])
        config_read_check1(12'h00, 32'h04, 32'h0000_0004); // check ap_idle = 1 (0x00 [bit 2])
        stop <= 1;
        @(posedge axis_clk);
        stop <= 0;
//-----complete-----//
        if (error == 0 & error_coef == 0) begin
            $display("---------------------------------------------");
            $display("-----------Congratulations! Pass-------------");
        end
        else begin
            $display("--------Simulation Failed---------");
        end
        $finish;
    end

    //Prevent hang
    integer timeout = (100000);
    initial begin
        while(timeout > 0) begin
            @(posedge axis_clk);
            timeout = timeout - 1;
        end
        $display($time, "Simualtion Hang ....");
        $finish;
    end

//-----AXI Lite write-----//
    task config_write0;
        input [11:0]    addr;
        input [31:0]    data;
        begin
            begin
                @(posedge axis_clk);
                awvalid <= 1; awaddr <= addr;
                wvalid  <= 1; wdata <= data;                  
            end
            fork
                begin
                    while (!awready) @(posedge axis_clk);
                    awvalid<=0;
		            awaddr<=0;
                end
                begin
                    while (!wready) @(posedge axis_clk);
                    wvalid<=0;                    
                    wdata<=0;
                end
            join 
		//@(posedge axis_clk);
        end
    endtask


    task config_write1;
        input [11:0]    addr;
        input [31:0]    data;
        begin
            @(posedge axis_clk);
            awvalid = 0;
            wvalid = 0;
            
            fork
                begin
                    wvalid  <= 1; wdata <= data;
                    //awvalid <= 1; awaddr <= addr;
                    repeat (3) @(posedge axis_clk);
                    //wvalid  <= 1; wdata <= data;
                    awvalid <= 1; awaddr <= addr;
                    
                end
                begin
                    @(posedge axis_clk);
                    while (!awready) @(posedge axis_clk);
                    awvalid<=0;
                    awaddr<=0;
                end
                begin
                    @(posedge axis_clk);
                    while (!wready) @(posedge axis_clk);
                    wvalid<=0;   
                    wdata<=0;                 
                
                end
            join 
        end
    endtask

    task config_write2;
        input [11:0]    addr;
        input [31:0]    data;
        begin
            @(posedge axis_clk);
            awvalid = 0;
            wvalid = 0;
            fork
                begin
                    
                    //wvalid  <= 1; wdata <= data;
                    awvalid <= 1; awaddr <= addr;
                    repeat (5) @(posedge axis_clk);
                    wvalid  <= 1; wdata <= data;
                    //awvalid <= 1; awaddr <= addr;
                end
                begin
                    @(posedge axis_clk);
                    while (!awready) @(posedge axis_clk);
                    awvalid<=0;
                    awaddr<=0;
                end
                begin
                    @(posedge axis_clk);
                    while (!wready) @(posedge axis_clk);
                    wvalid<=0;   
                    wdata<=0;                 
                
                end
            join 
        end
    endtask

//-----AXI Lite read-----//
    task config_read_check0;
        input [11:0]        addr;
        input signed [31:0] exp_data;
        input [31:0]        mask;
        begin
            begin
                  @(posedge axis_clk);
                    arvalid <= 1; araddr <= addr;
                    rready <= 1;
            end
            fork 
                begin
                    @(posedge axis_clk);
                    while (!arready) @(posedge axis_clk);
                    arvalid<=0;
		            araddr<=0;
                end
                begin
                    @(posedge axis_clk);
                    while (!(rvalid & rready)) @(posedge axis_clk);
                    if( (rdata & mask) != (exp_data & mask)) begin
                        $display("ERROR: exp = %d, rdata = %d", exp_data, rdata);
                        error_coef <= 1;
                    end else begin
                        $display("OK: exp = %d, rdata = %d", exp_data, rdata);
                    end
                    rready<=0;                
                end
            join 
        end
    endtask

    task config_read_check1;
        input [11:0]        addr;
        input signed [31:0] exp_data;
        input [31:0]        mask;
        begin
            
              @(posedge axis_clk);
              arvalid <= 1; araddr <= addr;
              rready <= 0;
            
            fork 
                begin
                    repeat (5)@(posedge axis_clk);
                    rready <= 1;
                end
                begin
                    @(posedge axis_clk);
                    while (!arready) @(posedge axis_clk);
                    arvalid<=0;
		            araddr<=0;
                end
                begin
                    @(posedge axis_clk);
                    while (!(rvalid & rready)) @(posedge axis_clk);
                    if( (rdata & mask) != (exp_data & mask)) begin
                        $display("ERROR: exp = %d, rdata = %d", exp_data, rdata);
                        error_coef <= 1;
                    end else begin
                        $display("OK: exp = %d, rdata = %d", exp_data, rdata);
                    end
                    rready<=0;                
                end
            join 
        end
    endtask

    task config_read_check2;
        input [11:0]        addr;
        input signed [31:0] exp_data;
        input [31:0]        mask;
        begin 
            @(posedge axis_clk);
            arvalid <= 1; araddr <= addr;
            rready <= 0;
            fork 
                begin
                    @(posedge axis_clk);
                    while (!arready) @(posedge axis_clk);
                    arvalid<=0;
		            araddr<=0;
                end
                begin
                    @(posedge axis_clk);
                    while (!(rvalid & rready)) @(posedge axis_clk);
                    repeat(2) @(posedge axis_clk); //rready depends on ar_signal
                    rready <= 1;
                    while (!(rvalid && rready)) @(posedge axis_clk);
                    if( (rdata & mask) != (exp_data & mask)) begin
                        $display("ERROR: exp = %d, rdata = %d", exp_data, rdata);
                        error_coef <= 1;
                    end else begin
                        $display("OK: exp = %d, rdata = %d", exp_data, rdata);
                    end
                    rready<=0;                
                end
            join 
        end
    endtask

//-----AXI Stream input-----//
    task axi_stream_master0;
        input  signed [31:0] in1;
        begin
            @(posedge axis_clk)
            ss_tvalid <= 1;
            ss_tdata  <= in1;
            while (!ss_tready) @(posedge axis_clk);
            ss_tvalid <= 0;
            ss_tdata <= 0;
        end
    endtask

   task axi_stream_master1;
            input  signed [31:0] in1;
        begin
            @(posedge axis_clk);
            ss_tvalid <= 1;
            ss_tdata  <= in1;
            @(posedge axis_clk);
            while (!ss_tready) @(posedge axis_clk);
            ss_tvalid <= 0;
            ss_tdata <=0;
            repeat(40) @(posedge axis_clk);
        end
   endtask

//-----AXI Stream output-----//
    task sm0;
        input   signed [31:0] in2; // golden data
        input         [31:0] pcnt; // pattern count
        begin
            @(posedge axis_clk) 
            sm_tready <= 1;
            while(!sm_tvalid) @(posedge axis_clk);
            sm_tready <=0;
            if (sm_tdata != in2) begin
                $display("[ERROR] [Pattern %d] Golden answer: %d, Your answer: %d", pcnt, in2, sm_tdata);
                error <= 1;
            end
            else begin
                $display("[PASS] [Pattern %d] Golden answer: %d, Your answer: %d", pcnt, in2, sm_tdata);
            end
        end
    endtask

    task sm1;
        input   signed [31:0] in2; // golden data
        input         [31:0] pcnt; // pattern count
        begin
            @(posedge axis_clk) 
            sm_tready <= 1;
            @(posedge axis_clk);
            while(!sm_tvalid) @(posedge axis_clk);
            sm_tready <=0;
            if (sm_tdata != in2) begin
                $display("[ERROR] [Pattern %d] Golden answer: %d, Your answer: %d", pcnt, in2, sm_tdata);
                error <= 1;
            end
            else begin
                $display("[PASS] [Pattern %d] Golden answer: %d, Your answer: %d", pcnt, in2, sm_tdata);
            end
            repeat(40) @(posedge axis_clk);
        end
    endtask
initial 
begin
    $dumpfile("fir.vcd");
    $dumpvars();
end
endmodule

