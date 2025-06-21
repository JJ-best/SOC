module butterfly
#(  
    parameter pDATA_WIDTH = 128 // two 64-bit numbers represent real & imaginary part
)
(
    input   wire clk,
    input   wire rst_n,

    input   wire [1:0] mode, // /iNTT(11)/NTT(10)/iFFT(01)/FFT(00)

    input   wire i_vld,
    output  reg  i_rdy,
    
    output  wire o_vld,
    input   wire o_rdy,

    input   wire [(pDATA_WIDTH-1):0] ai, // are(64bit)+aim(64bit)
    input   wire [(pDATA_WIDTH-1):0] bi, // bre(64bit)+bim(64bit)
    input   wire [(pDATA_WIDTH-1):0] gm, // gre(64bit)+gim(64bit)
    output  wire [(pDATA_WIDTH-1):0] ao,
    output  wire [(pDATA_WIDTH-1):0] bo

);
//==================================================================================//

localparam NTT_MUL_LATENCY = 17;
localparam FFT_MUL_LATENCY = 20;

localparam NTT_LATENCY     = 21;
localparam iNTT_LATENCY    = 21;//?
localparam FFT_LATENCY     = 27;
localparam iFFT_LATENCY    = 27;//?

// localparam mode_NTT        = 2'b00;
// localparam mode_iNTT       = 2'b01;
// localparam mode_FFT        = 2'b10;
// localparam mode_iFFT       = 2'b11;
localparam mode_NTT        = 2'b10;
localparam mode_iNTT       = 2'b11;
localparam mode_FFT        = 2'b00;
localparam mode_iFFT       = 2'b01;
//==================================================================================//
localparam pFP_WIDTH            = 64 ;
localparam pNTT_WTDTH           = 16 ;
//==================================================================================//
reg  [1:0]                  mode_state ;
reg  [1:0]                  mode_state_next;
//==================================================================================//
wire [(pFP_WIDTH-1):0]      gre_inv;
wire [(pFP_WIDTH-1):0]      gim_inv;
wire [(pDATA_WIDTH-1):0]    gm_inv;
wire [(pDATA_WIDTH-1):0]    gm_mul2;
reg  [(pDATA_WIDTH-1):0]    a_reg[0:(FFT_MUL_LATENCY-1)];
wire [(pDATA_WIDTH-1):0]    a_result;
wire [(pDATA_WIDTH-1):0]    mul_result_int[0:1];
wire [(pDATA_WIDTH-1):0]    mul_result_com[0:1];
wire [(pDATA_WIDTH-1):0]    mul_result[0:1];
wire                        mul_out_valid[0:1];
wire                        cmul_valid_i[0:1];
wire                        cmul_valid_o[0:1];
wire [(pDATA_WIDTH-1):0]    cmul_result[0:1];
wire                        mont_add_valid_o0[0:7];
wire                        mont_add_valid_o1[0:7];
wire [(pDATA_WIDTH-1):0]    mont_add_result;
wire [(pDATA_WIDTH-1):0]    mont_sub_result;
reg  [4:0]                  count;
reg                         pass;
//==================================================================================//

assign gre_inv = {~gm[(pFP_WIDTH*2-1)], gm[(pFP_WIDTH*2-2):pFP_WIDTH]};
assign gim_inv = {~gm[(pFP_WIDTH-1)], gm[(pFP_WIDTH-2):0]};
assign gm_inv  = {gre_inv, gim_inv};
assign gm_mul2 = (mode_state[1] == 1'b0)? gm_inv:gm;//NTT use gm(unsign)


//==================================================================================//
//i_rdy controller
always @(*) begin
    case (mode_state)
        mode_NTT: begin 
            mode_state_next = mode;
            if (mode == mode_iNTT && i_vld) begin
                if (count == iNTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iNTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_FFT && i_vld) begin
                if (count == FFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == FFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_iFFT && i_vld) begin
                if (count == iFFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iFFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else begin //NTT
                pass = 1'b1;
                i_rdy = 1'b1;
            end
        end
        mode_iNTT: begin
            mode_state_next = mode;
            if (mode == mode_NTT && i_vld) begin
                if (count == NTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == NTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_FFT) begin
                if (count == FFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == FFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_iFFT) begin
                if (count == iFFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iFFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else begin //iNTT
                pass = 1'b1;
                i_rdy = 1'b1;
            end
        end
        mode_FFT: begin //00
            mode_state_next = mode;
            if (mode == mode_NTT && i_vld) begin
                if (count == NTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == NTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_iNTT) begin
                if (count == iNTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iNTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_iFFT) begin
                if (count == iFFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iFFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else begin //FFT
                pass = 1'b1;
                i_rdy = 1'b1;
            end
        end
        mode_iFFT: begin
            mode_state_next = mode;
            if (mode == mode_NTT && i_vld) begin
                if (count == NTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == NTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_iNTT) begin
                if (count == iNTT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == iNTT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else if (mode == mode_FFT) begin
                if (count == FFT_LATENCY - 1) begin
                    pass = 1'b1;
                end else begin
                    pass = 1'b0;
                end
                if (count == FFT_LATENCY) begin
                    i_rdy = 1'b1;
                end else begin
                    i_rdy = 1'b0;
                end
            end else begin //iFFT
                pass = 1'b1;
                i_rdy = 1'b1;
            end
        end
        default: begin
            pass = 1'b1;
            i_rdy = 1'b1;
        end  
    endcase
end

always @(posedge clk or negedge rst_n) begin
     if (!rst_n) begin
       mode_state <= mode_NTT;
     end else if (i_vld & pass) begin
       mode_state <= mode_state_next;
     end else begin
       mode_state <= mode_state;
     end
end

//counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 0;
    end else if (!pass) begin //mode change
      count <= count + 1'b1;
    end else begin
      count <= 0;
    end
end

//==================================================================================//
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < FFT_MUL_LATENCY; i = i + 1) begin
          a_reg[i] <= {(pDATA_WIDTH){1'b0}};
        end
    end else begin
        a_reg[0] <= ai;
        for (i = 1; i < FFT_MUL_LATENCY; i = i + 1) begin
          a_reg[i] <= a_reg[i-1];
        end
    end
end
//bi * gm
mul mul1(
    .in_A(bi),
    .in_B(gm),
    .mode(mode_state[1]), // * set mode = 0 to do complex mul ， mode = 1 to do int mul
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(i_vld & i_rdy),
    .result_c(mul_result_com[0]),  
    .result_int(mul_result_int[0]),
    .out_valid(mul_out_valid[0])
);
assign mul_result[0] = (mode_state[1] == 1'b0 )? mul_result_com[0]:mul_result_int[0];
//bi * -gm(FFT), bi * gm(NTT)
mul mul2(
    .in_A(bi),
    .in_B(gm_mul2),
    .mode(mode_state[1]), // * set mode = 0 to do complex mul ， mode = 1 to do int mul
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(i_vld & i_rdy),
    .result_c(mul_result_com[1]),  
    .result_int(mul_result_int[1]),
    .out_valid(mul_out_valid[1])
);
assign mul_result[1] = (mode_state[1] == 1'b0 )? mul_result_com[1]:mul_result_int[1];
assign a_result = (mode_state[1] == 1'b0)? a_reg[(FFT_MUL_LATENCY-1)]:a_reg[(NTT_MUL_LATENCY-1)];

fp_add   fp_add_01( .in_A( a_result[(pFP_WIDTH-1):0] )             , .in_B( mul_result[0][(pFP_WIDTH-1)  :0] )               , .clk( clk ) , .rst_n( rst_n )  , .in_valid( mul_out_valid[0] )  , .result( cmul_result[0][(pFP_WIDTH-1):0] )             , .out_valid( cmul_valid_o[0] ));
fp_add   fp_add_02( .in_A( a_result[(pFP_WIDTH*2-1):(pFP_WIDTH)] ) , .in_B( mul_result[0][(pFP_WIDTH*2-1):(pFP_WIDTH)] )     , .clk( clk ) , .rst_n( rst_n )  , .in_valid( mul_out_valid[1] )  , .result( cmul_result[0][(pFP_WIDTH*2-1):(pFP_WIDTH)] ) , .out_valid( cmul_valid_o[1] ));
fp_add   fp_add_11( .in_A( a_result[(pFP_WIDTH-1):0] )             , .in_B( mul_result[1][(pFP_WIDTH-1):0] )                 , .clk( clk ) , .rst_n( rst_n )  , .in_valid( mul_out_valid[0] )  , .result( cmul_result[1][(pFP_WIDTH-1):0] )             , .out_valid( cmul_valid_o[0] ));
fp_add   fp_add_12( .in_A( a_result[(pFP_WIDTH*2-1):(pFP_WIDTH)] ) , .in_B( mul_result[1][(pFP_WIDTH*2-1):(pFP_WIDTH)] )     , .clk( clk ) , .rst_n( rst_n )  , .in_valid( mul_out_valid[1] )  , .result( cmul_result[1][(pFP_WIDTH*2-1):(pFP_WIDTH)] ) , .out_valid( cmul_valid_o[1] ));

mont_add mont_add_01(.in_A(mul_result[0][(pNTT_WTDTH-1):0])               , .in_B(a_result[(pNTT_WTDTH-1)  :0])             , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH-1)    :0])             , .out_valid(mont_add_valid_o0[0]));
mont_add mont_add_02(.in_A(mul_result[0][(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .in_B(a_result[(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*2-1)  :(pNTT_WTDTH)])  , .out_valid(mont_add_valid_o0[1]));
mont_add mont_add_03(.in_A(mul_result[0][(pNTT_WTDTH*3-1):(2*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*3-1):(pNTT_WTDTH*2)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*3-1)  :(pNTT_WTDTH*2)]), .out_valid(mont_add_valid_o0[2]));
mont_add mont_add_04(.in_A(mul_result[0][(pNTT_WTDTH*4-1):(3*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*4-1):(pNTT_WTDTH*3)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*4-1)  :(pNTT_WTDTH*3)]), .out_valid(mont_add_valid_o0[3]));
mont_add mont_add_05(.in_A(mul_result[0][(pNTT_WTDTH*5-1):(4*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*5-1):(pNTT_WTDTH*4)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*5-1)  :(pNTT_WTDTH*4)]), .out_valid(mont_add_valid_o0[4]));
mont_add mont_add_06(.in_A(mul_result[0][(pNTT_WTDTH*6-1):(5*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*6-1):(pNTT_WTDTH*5)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*6-1)  :(pNTT_WTDTH*5)]), .out_valid(mont_add_valid_o0[5]));
mont_add mont_add_07(.in_A(mul_result[0][(pNTT_WTDTH*7-1):(6*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*7-1):(pNTT_WTDTH*6)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*7-1)  :(pNTT_WTDTH*6)]), .out_valid(mont_add_valid_o0[6]));
mont_add mont_add_08(.in_A(mul_result[0][(pNTT_WTDTH*8-1):(7*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*8-1):(pNTT_WTDTH*7)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[0]), .result(mont_add_result[(pNTT_WTDTH*8-1)  :(pNTT_WTDTH*7)]), .out_valid(mont_add_valid_o0[7]));

// mont_sub mont_sub_11(.in_A(mul_result[1][(pNTT_WTDTH-1):0])               , .in_B(a_result[(pNTT_WTDTH-1)  :0])             , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH-1)    :0])             , .out_valid(mont_add_valid_o1[0]));
// mont_sub mont_sub_12(.in_A(mul_result[1][(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .in_B(a_result[(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*2-1)  :(pNTT_WTDTH)])  , .out_valid(mont_add_valid_o1[1]));
// mont_sub mont_sub_13(.in_A(mul_result[1][(pNTT_WTDTH*3-1):(2*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*3-1):(pNTT_WTDTH*2)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*3-1)  :(pNTT_WTDTH*2)]), .out_valid(mont_add_valid_o1[2]));
// mont_sub mont_sub_14(.in_A(mul_result[1][(pNTT_WTDTH*4-1):(3*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*4-1):(pNTT_WTDTH*3)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*4-1)  :(pNTT_WTDTH*3)]), .out_valid(mont_add_valid_o1[3]));
// mont_sub mont_sub_15(.in_A(mul_result[1][(pNTT_WTDTH*5-1):(4*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*5-1):(pNTT_WTDTH*4)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*5-1)  :(pNTT_WTDTH*4)]), .out_valid(mont_add_valid_o1[4]));
// mont_sub mont_sub_16(.in_A(mul_result[1][(pNTT_WTDTH*6-1):(5*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*6-1):(pNTT_WTDTH*5)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*6-1)  :(pNTT_WTDTH*5)]), .out_valid(mont_add_valid_o1[5]));
// mont_sub mont_sub_17(.in_A(mul_result[1][(pNTT_WTDTH*7-1):(6*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*7-1):(pNTT_WTDTH*6)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*7-1)  :(pNTT_WTDTH*6)]), .out_valid(mont_add_valid_o1[6]));
// mont_sub mont_sub_18(.in_A(mul_result[1][(pNTT_WTDTH*8-1):(7*pNTT_WTDTH)]), .in_B(a_result[(pNTT_WTDTH*8-1):(pNTT_WTDTH*7)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*8-1)  :(pNTT_WTDTH*7)]), .out_valid(mont_add_valid_o1[7]));

mont_sub mont_sub_11(.in_A(a_result[(pNTT_WTDTH-1)  :0])             , .in_B(mul_result[1][(pNTT_WTDTH-1):0])             , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH-1)    :0])             , .out_valid(mont_add_valid_o1[0]));
mont_sub mont_sub_12(.in_A(a_result[(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .in_B(mul_result[1][(pNTT_WTDTH*2-1):(pNTT_WTDTH)])  , .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*2-1)  :(pNTT_WTDTH)])  , .out_valid(mont_add_valid_o1[1]));
mont_sub mont_sub_13(.in_A(a_result[(pNTT_WTDTH*3-1):(pNTT_WTDTH*2)]), .in_B(mul_result[1][(pNTT_WTDTH*3-1):(2*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*3-1)  :(pNTT_WTDTH*2)]), .out_valid(mont_add_valid_o1[2]));
mont_sub mont_sub_14(.in_A(a_result[(pNTT_WTDTH*4-1):(pNTT_WTDTH*3)]), .in_B(mul_result[1][(pNTT_WTDTH*4-1):(3*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*4-1)  :(pNTT_WTDTH*3)]), .out_valid(mont_add_valid_o1[3]));
mont_sub mont_sub_15(.in_A(a_result[(pNTT_WTDTH*5-1):(pNTT_WTDTH*4)]), .in_B(mul_result[1][(pNTT_WTDTH*5-1):(4*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*5-1)  :(pNTT_WTDTH*4)]), .out_valid(mont_add_valid_o1[4]));
mont_sub mont_sub_16(.in_A(a_result[(pNTT_WTDTH*6-1):(pNTT_WTDTH*5)]), .in_B(mul_result[1][(pNTT_WTDTH*6-1):(5*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*6-1)  :(pNTT_WTDTH*5)]), .out_valid(mont_add_valid_o1[5]));
mont_sub mont_sub_17(.in_A(a_result[(pNTT_WTDTH*7-1):(pNTT_WTDTH*6)]), .in_B(mul_result[1][(pNTT_WTDTH*7-1):(6*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*7-1)  :(pNTT_WTDTH*6)]), .out_valid(mont_add_valid_o1[6]));
mont_sub mont_sub_18(.in_A(a_result[(pNTT_WTDTH*8-1):(pNTT_WTDTH*7)]), .in_B(mul_result[1][(pNTT_WTDTH*8-1):(7*pNTT_WTDTH)]), .clk(clk), .rst_n(rst_n), .in_valid(mul_out_valid[1]), .result(mont_sub_result[(pNTT_WTDTH*8-1)  :(pNTT_WTDTH*7)]), .out_valid(mont_add_valid_o1[7]));

assign ao = (mode_state[1] == 1'b0)? cmul_result[0] : mont_add_result;
assign bo = (mode_state[1] == 1'b0)? cmul_result[1] : mont_sub_result;
assign o_vld = (mode_state[1] == 1'b0)? cmul_valid_o[0] & cmul_valid_o[1] : mont_add_valid_o0[0] ;
    // complex mul & add & sub for FFT/iFFT

    // Complex Multiplication:
    // y_re = (a_re * b_re) - (a_im * b_im)
    // y_im = (a_re * b_im) + (a_im * b_re)
    // Rewrite as:
    // y_re = a_re * (b_re - b_im) + b_im * (a_re - a_im)
    // y_im = a_im * (b_re + b_im) + b_im * (a_re - a_im)
    // It will reduce the mul usage from 4 to 3 since we reuse [b_im * (a_re - a_im)]

    // montgomery mul & add & sub for NTT/iNTT

endmodule

