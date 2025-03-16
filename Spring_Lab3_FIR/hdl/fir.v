// version 11: AXI Lite Asynchrounous



module fir 
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11
)
(
//-----AXI Lite write-----//
    output  wire                     awready, //replace to wire
    output  wire                     wready,  //replace to wire
    input   wire                     awvalid,
    input   wire [(pADDR_WIDTH-1):0] awaddr,
    input   wire                     wvalid,
    input   wire [(pDATA_WIDTH-1):0] wdata,
//-----AXI Lite read-----//
    output  wire                     arready,//replace to wire
    input   wire                     rready,
    input   wire                     arvalid,
    input   wire [(pADDR_WIDTH-1):0] araddr,
    output  wire                     rvalid, //replace to wire
    output  reg  [(pDATA_WIDTH-1):0] rdata,   //replace to wire
//-----AXI Stream, input data Xn-----//
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  reg                     ss_tready, 
    input   wire                     sm_tready, 
    output  wire                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast, 
    
    // bram for tap RAM
    output  wire [3:0]               tap_WE, //replace to wire
    output  wire                     tap_EN, //replace to wire
    output  reg  [(pDATA_WIDTH-1):0] tap_Di, //replace to wire
    output  reg [(pADDR_WIDTH-1):0] tap_A,  
    input   wire [(pDATA_WIDTH-1):0] tap_Do, 

    // bram for data RAM
    output  wire [3:0]               data_WE,
    output  wire                     data_EN,
    output  wire [(pDATA_WIDTH-1):0] data_Di,
    output  wire  [(pADDR_WIDTH-1):0] data_A,
    input   wire [(pDATA_WIDTH-1):0] data_Do,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n
);

localparam  AP_INIT = 2'b00; //ap state
localparam  AP_START = 2'b01;
localparam  AP_DONE = 2'b10;
localparam  AP_FRESH = 2'b11;

localparam W_IDLE = 2'b00;
localparam W_READY = 2'b01;
localparam W_HOLD = 2'b10;
localparam W_DONE = 2'b11;

localparam AW_IDLE = 2'b00;
localparam AW_READY = 2'b01;
localparam AW_HOLD = 2'b10;
localparam AW_DONE = 2'b11;

localparam AR_IDLE = 2'b00;
localparam AR_READY = 2'b01;
localparam AR_HOLD = 2'b10;
localparam AR_DONE = 2'b11;

localparam R_IDLE = 2'b00;
localparam R_VALID = 2'b01;
localparam R_DONE = 2'b10;

localparam SS_IDLE = 3'b000;
localparam SS_DONE = 3'b001;
localparam SS_WRITE = 3'b010;
localparam SS_PROC1 = 3'b011;
localparam SS_PROC = 3'b100;
localparam SS_HOLD = 3'b101;

localparam SM_IDLE = 3'b000;
localparam SM_WAIT1 = 3'b001;
localparam SM_WAIT2 = 3'b010;
localparam SM_DONE = 3'b011;
localparam SM_LATCH = 3'b100;

localparam SS_MODE = 1'b0;
localparam SM_MODE = 1'b1;

reg [(pADDR_WIDTH-1) : 0] tap_A_tmp;
reg [(pDATA_WIDTH-1) : 0] data_length;
wire [(pDATA_WIDTH-1) : 0] data_length_next;
wire [(pDATA_WIDTH-1) : 0] data_length_in;
wire data_length_ctrl;
reg [(pDATA_WIDTH-1) : 0] coef_length;
wire [(pDATA_WIDTH-1) : 0] coef_length_next;
wire [(pDATA_WIDTH-1) : 0] coef_length_in;
wire coef_length_ctrl;
reg [2 : 0] ap_ctrl;
wire [2 : 0] ap_ctrl_next;
wire [2 : 0] ap_ctrl_in;
wire ap_ctrl_ctrl;
reg [1:0] ap_state;
reg [1:0] ap_state_next;
reg [2 : 0] ap_ctrl_fir;
reg [(pADDR_WIDTH-1) : 0] tap_addr_generator;
wire [(pADDR_WIDTH-1) : 0] tap_addr_generator_next;
//wire [(pADDR_WIDTH-1) : 0] tap_addr_max;
reg [(pDATA_WIDTH-1) : 0] data_cnt; // count how many data have been process.
wire [(pDATA_WIDTH-1) : 0] data_cnt_next; // cnt = 600, state = done
wire [(pADDR_WIDTH-1) : 0] tap_A_max;
wire [(pADDR_WIDTH-1) : 0] addr_max;
reg [(pADDR_WIDTH-1):0] data_addr_w;
wire [(pADDR_WIDTH-1):0] data_addr_w_next;
reg [(pADDR_WIDTH-1) : 0] data_addr_r;
wire [(pADDR_WIDTH-1) : 0] data_addr_r_next;
wire [(pDATA_WIDTH-1) : 0] data_x;
wire [(pDATA_WIDTH-1) : 0] tap_h;
wire [(pDATA_WIDTH-1) : 0] x_mul_h_next;
wire [(pDATA_WIDTH-1) : 0] y_next;
reg [(pDATA_WIDTH-1) : 0] x_mul_h;
reg [(pDATA_WIDTH-1) : 0] y;
reg [2:0] ss_state;
reg [2:0] ss_state_next;

//-----AXI Lite-----//
reg [1:0] w_state;
reg [1:0] w_state_next;
reg [1:0] aw_state;
reg [1:0] aw_state_next;
reg [1:0] r_state;
reg [1:0] r_state_next;
reg [1:0] ar_state;
reg [1:0] ar_state_next;
reg [(pDATA_WIDTH-1) : 0] tap_Di_next;
reg [(pADDR_WIDTH-1) : 0] tap_A_next;
reg [(pADDR_WIDTH-1) : 0] tap_A_hold;
reg [2:0] sm_state;
reg [2:0] sm_state_next;
wire y_latch_en;
reg [(pDATA_WIDTH-1) : 0] y_latch;
reg [(pDATA_WIDTH-1) : 0] y_latch_next;
reg mode_state;
reg mode_state_next;

reg [(pADDR_WIDTH-1):0]data_addr_f;
wire [(pADDR_WIDTH-1):0]data_addr_f_next;
wire fresh;

reg [(pDATA_WIDTH-1):0] ss_tdata_tmp;

//-----FSM of write-----//
always @(*) begin
  case (w_state)
    W_IDLE: begin //0
      if (wvalid) begin
        w_state_next = W_READY;
      end else begin
        w_state_next = W_IDLE;
      end
    end
    W_READY: begin //1
      if ((aw_state == AW_READY) | (aw_state == AW_HOLD)) begin
        w_state_next = W_DONE;
      end else begin
        w_state_next = W_HOLD;
      end
    end
    W_HOLD: begin //2
      if (aw_state == AW_READY) begin
        w_state_next = W_DONE;
      end else begin
        w_state_next = W_HOLD;
      end
    end
    W_DONE: begin //3
      if (wvalid) begin
        w_state_next = W_READY;
      end else begin
        w_state_next = W_IDLE;
      end
    end
  endcase
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    w_state <= W_IDLE;
  end else begin
    w_state <= w_state_next;
  end
end
assign wready = (w_state == W_READY)? 1 : 0;

//-----FSM of awrite-----//
always @(*) begin
  case (aw_state)
    AW_IDLE: begin //0
      if (awvalid) begin
        aw_state_next = AW_READY;
      end else begin
        aw_state_next = AW_IDLE;
      end
    end
    AW_READY: begin //1
      if (w_state == W_READY | w_state == W_HOLD) begin
        aw_state_next = AW_DONE;
      end else begin
        aw_state_next = AW_HOLD;
      end
    end
    AW_HOLD: begin //2
      if (w_state == W_READY) begin
        aw_state_next = AW_DONE;
      end else begin
        aw_state_next = AW_HOLD;
      end
    end
    AW_DONE: begin //3
      if (awvalid) begin
        aw_state_next = AW_READY;
      end else begin
        aw_state_next = AW_IDLE;
      end
    end
  endcase
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    aw_state <= AW_IDLE;
  end else begin
    aw_state <= aw_state_next;
  end
end
assign awready = (aw_state == AW_READY)? 1 : 0;

//-----FSM of read-----//


always @(*) begin
  case (r_state)
    R_IDLE: begin //0
      if ((rready & arvalid) | (ar_state == AR_READY)) begin
        r_state_next = R_VALID;
      end else begin
        r_state_next = R_IDLE;
      end
    end
    R_VALID: begin //1
      if (rready) begin
        r_state_next = R_DONE;
      end else begin
        r_state_next = R_VALID;
      end
    end
    R_DONE: begin //2
      if ((rready & arvalid) | (rready == 1 && ar_state == AR_HOLD)) begin
        r_state_next = R_VALID;
      end else begin
        r_state_next = R_IDLE;
      end
    end
    default : begin
      r_state_next = R_IDLE;
    end
  endcase
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    r_state <= R_IDLE;
  end else begin
    r_state <= r_state_next;
  end
end
assign rvalid = (r_state == R_VALID)? 1 : 0;

//-----FSM of ARREAD-----//
always @(*) begin
  case (ar_state)
    AR_IDLE: begin //0
      if (arvalid) begin
        ar_state_next = AR_READY;
      end else begin
        ar_state_next = AR_IDLE;
      end
    end
    AR_READY: begin
      if (rvalid & rready) begin
        ar_state_next = AR_DONE;
      end else begin
        ar_state_next = AR_HOLD;
      end
    end
    AR_HOLD: begin
      if (rvalid & rready) begin
        ar_state_next = AR_DONE;
      end else begin
        ar_state_next = AR_HOLD;
      end
    end 
    AR_DONE: begin
      if (arvalid) begin
        ar_state_next = AR_READY;
      end else begin
        ar_state_next = AR_IDLE;
      end
    end
  endcase
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ar_state <= AR_IDLE;
  end else begin
    ar_state <= ar_state_next;
  end
end
assign arready = (ar_state == AR_READY)? 1 : 0;


always @(*) begin
  if (w_state == W_READY) begin
    tap_Di_next = wdata;
  end else begin
    tap_Di_next = tap_Di;
  end
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    tap_Di <= 0;
  end else if (w_state == W_DONE && aw_state == AW_DONE) begin
    tap_Di <= 0;
  end else begin
    tap_Di <= tap_Di_next;
  end
end


always @(*) begin
  if (aw_state == AW_READY) begin
    tap_A_next = awaddr;
  end else if (ar_state == AR_READY) begin
    tap_A_next = araddr;
  end else begin
    tap_A_next = tap_A_hold;
  end
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    tap_A_hold <= 0;
  end else begin
    tap_A_hold <= tap_A_next;
  end
end

always @(*) begin
  if (rready & arvalid && ap_ctrl == 3'b100) begin
    tap_A = araddr[6:0]; //如果ar 和 r是同步訊號
  end else if (arvalid & arready && ap_ctrl == 3'b100) begin 
    tap_A = araddr[6:0];
  end else if (ap_ctrl == 3'b100) begin
    tap_A = tap_A_hold[6:0]; //如果r比較慢
  end else if (ap_ctrl == 3'b001) begin
    tap_A = tap_addr_generator[6:0];
  end else begin
    tap_A = 0;
  end
end

assign tap_EN = ((tap_A_hold != 12'h10 && tap_A_hold != 12'h14 && tap_A_hold != 12'h00) | ap_ctrl[0] == 1)? 1 : 0;
assign tap_WE = (w_state == W_DONE && aw_state == AW_DONE && (ap_ctrl == 3'b100))? 4'b1111 : 4'b0000; // handshake: wvalid && wready
//assign rdata = (rvalid && rready)? ((araddr != 32'h00)? tap_Do : ap_ctrl) : 0; //handshake: rvalid = rvalid && rready

always @(*) begin
  if (ar_state == AR_READY && r_state == R_VALID && (rvalid & rready)) begin
    case (araddr)
      12'h00: begin//ap_ctrl
        rdata = ap_ctrl;
      end
      12'h10: begin//data_length
        rdata = data_length;
      end
      12'h14: begin//coef_length
        rdata = coef_length;
      end
      default: begin
        rdata = (ap_ctrl != 3'b001)? tap_Do : 32'hFFFF_FFFF;
      end
    endcase  
  end else if (rready & rvalid) begin
    case (tap_A_hold)
      12'h00: begin//ap_ctrl
        rdata = ap_ctrl;
      end
      12'h10: begin//data_length
        rdata = data_length;
      end
      12'h14: begin//coef_length
        rdata = coef_length;
      end
      default: begin
        rdata = (ap_ctrl != 3'b001)? tap_Do : 32'hFFFF_FFFF;
      end
    endcase
  end else begin
    rdata = 32'h0000_0000;
  end
end

//-----configuration register: data_length(addr:0x10) (AXI Lite)-----//
//-----configuration register: coef_length(addr:0x14) (AXI Lite)-----//
//-----configuration register: ap_ctrl(addr:0x00) (AXI Lite)-----//
//-----ap_ctrl can use AXI Lite to write, or decided by fir state-----//
assign data_length_next = (tap_A_hold == 12'h10 && w_state == W_DONE && aw_state == AW_DONE)? tap_Di : data_length;
assign coef_length_next = (tap_A_hold == 12'h14 && w_state == W_DONE && aw_state == AW_DONE)? tap_Di : coef_length;
assign ap_ctrl_next = (tap_A_hold == 12'h00 && w_state == W_DONE && aw_state == AW_DONE)? tap_Di : ap_ctrl_fir; 

always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      data_length <= 32'h0;
      coef_length <= 32'h0;
      ap_ctrl <= 3'b100; //ap_idle
    end else begin
      data_length <= data_length_next;
      coef_length <= coef_length_next;
      ap_ctrl <= ap_ctrl_next;  //program by tb
    end
end

//-----FSM of fir, determine ap_ctrl-----//
always @(*) begin
  case (ap_state)
  AP_INIT: begin //00 program start
    if (tap_A_hold == 12'h00 && tap_Di == 32'h1) begin
      ap_state_next = AP_FRESH;//program start
      ap_ctrl_fir = 3'b100;
    end else begin
      ap_state_next = AP_INIT;
      ap_ctrl_fir = 3'b100;
    end
  end
  AP_START: begin //01
    if (sm_tlast == 1) begin
      ap_state_next = AP_DONE;
      ap_ctrl_fir = 3'b010;
    end else begin
      ap_state_next = AP_START;
      ap_ctrl_fir = 3'b001;
    end
  end
  AP_DONE: begin //10 //讀完才重製
    if (araddr == 12'h0 && (rvalid & rready) && (!ss_tlast)) begin
      ap_state_next = AP_INIT;
      ap_ctrl_fir = 3'b100;
    end else begin
      ap_state_next = AP_DONE;
      ap_ctrl_fir = 3'b010;
    end
  end
  AP_FRESH: begin
    if (fresh) begin
      ap_state_next = AP_START;
      ap_ctrl_fir = 3'b101;
    end else begin
      ap_state_next = AP_FRESH;
      ap_ctrl_fir = 3'b100;
    end
  end
  default: begin
    ap_state_next = AP_INIT;
    ap_ctrl_fir = 3'b100;
  end
  endcase
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ap_state <= AP_INIT;
  end else begin
    ap_state <= ap_state_next;
  end
end

//-----tap RAM address generator 0x40-0xFF-----//
//assign  tap_addr_max = 12'h80 + 4 * (coef_length - 1);
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    tap_addr_generator <= 12'h80;
    //tap_addr_generator == tap_addr_max | ap_ctrl == 3'b101 | ap_ctrl == 3'b100 | ss_tready == 1
  end else if (mode_state == SM_MODE && data_cnt == data_length - 1) begin //這時ss會維持DONE
    tap_addr_generator <= tap_addr_generator_next; 
  end else if (ap_ctrl == 3'b100) begin
    tap_addr_generator <= 12'h80;
  end else if (ss_state == SS_DONE) begin
    tap_addr_generator <= 12'h80;
  end else begin
    tap_addr_generator <= tap_addr_generator_next; 
  end
end
assign tap_addr_generator_next = tap_addr_generator + 12'h4;

//-----AXI Stream-----//
//1. control ss_tready 
//if idle, write 0 in dataRAM
assign data_WE = ((ss_tready && ss_tvalid) | ap_ctrl == 3'b100)? 4'b1111 : 4'b0000; //handshake: ss_tready = ss_tready && ss_tvalid
assign data_EN = 1;
assign data_Di = (ap_ctrl == 3'b100)? 0 : ss_tdata;
//when BRAM getting address, it will access(r/w) memory in next clock.
//原版assign data_A = (ap_ctrl == 3'b100)? tap_A : (ss_tready & ss_tvalid) ? data_addr_w[6:0] : data_addr_r[6:0]; //generate by address generator
assign data_A = (ap_ctrl == 3'b100)? data_addr_f[6:0] : (ss_state == SS_DONE) ? data_addr_w[6:0] : data_addr_r[6:0]; //generate by address generator


assign tap_A_max = (coef_length - 1) * 4; //address for bram
assign addr_max = 12'h80 + (coef_length - 1) * 4;


always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ss_tdata_tmp <= 0;
  end else if (ss_state == SS_WRITE) begin
    ss_tdata_tmp <= ss_tdata_tmp;
  end else begin
    ss_tdata_tmp <= ss_tdata;
  end
end

//-----data RAM address generator 0x40-0xFF-----//
//1. axi_stream: write adress generate(FIFO, write data_RAM)
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    data_addr_w <= 12'h80;
  end else if (ap_ctrl == 3'b101) begin
    data_addr_w <= 12'h80;
  end else if (ss_state == SS_WRITE) begin//應該只有在第一次DONE時加值 或改成SSWRITE
    data_addr_w <= data_addr_w_next; //+4
  end else if (ap_ctrl == 3'b100) begin
    data_addr_w <= data_addr_w_next;
  end else begin
    data_addr_w <= data_addr_w; //maintain
  end
end
//refresh data_addr_w in each ss_tready
//write until bram is full(coeff_length)
assign  data_addr_w_next = (data_addr_w != addr_max)? data_addr_w + 12'h4 : 12'h80;
assign  data_addr_f_next = (data_addr_f != 12'h80 + 4 * (32-1))? data_addr_f + 12'h4 : 12'h80;

assign fresh = (data_addr_f == 12'h80 + 4 * (32-1))? 1:0;
//fresh
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    data_addr_f <= 12'h80;
  end else if (ap_state == AP_DONE) begin//應該只有在第一次DONE時加值 或改成SSWRITE
    data_addr_f <= 12'h80; 
  end else if (ap_state == AP_FRESH) begin
    data_addr_f <= data_addr_f_next;//+4
  end else begin
    data_addr_f <= data_addr_f; //maintain
  end
end
//refresh data_addr_w in each ss_tready
//write until bram is full(coeff_length)


//2. axi_stream: read address generate
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    data_addr_r <= 12'h80;
  end else if (ap_ctrl == 3'b100) begin 
    data_addr_r <= 12'h80;
  end else if (ss_state == SS_DONE) begin
    data_addr_r <= data_addr_w;
  end else begin
    data_addr_r <= data_addr_r_next;
  end
end
//if read to addr 12'h80, switch to the end of bram addr
assign data_addr_r_next = (data_addr_r == 12'h80)? 12'h80 + (coef_length - 1) * 4 : data_addr_r - 12'h4;

//-----core engine-----//
assign data_x = ((mode_state == SM_MODE && sm_state == SM_WAIT1) | ss_state == SS_PROC | ss_state == SS_PROC1 | (ss_state == SS_DONE && sm_state == SM_WAIT1))? data_Do : 0;//在write, process時
assign tap_h = ((mode_state == SM_MODE && sm_state == SM_WAIT1) | ss_state == SS_PROC | ss_state == SS_PROC1 | (ss_state == SS_DONE && sm_state == SM_WAIT1))? tap_Do : 0;
assign x_mul_h_next = data_x * tap_h;
assign y_next = x_mul_h + y;

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    y <= 0;
    x_mul_h <= x_mul_h_next;
  end else if (ap_ctrl == 3'b001 && ss_state == SS_PROC1) begin
    y <= 0;
    x_mul_h <= x_mul_h_next;
  end else if (ap_ctrl == 3'b001) begin
    y <= y_next;
    x_mul_h <= x_mul_h_next;
  end else begin
    y <= 0;
    x_mul_h <= 0;
  end
end

//-----FSM of ss-----//
always @(*) begin
  case (ss_state)
  SS_IDLE: begin //0
    if (ap_state == AP_START) begin
      ss_state_next = SS_DONE;
    end else begin
      ss_state_next = SS_IDLE;
    end
  end
  SS_DONE: begin //1
    if (ss_tvalid & ss_tready) begin
      ss_state_next = SS_WRITE;
    end else begin
      ss_state_next = SS_DONE;
    end
  end
  SS_WRITE: begin //2
    ss_state_next = SS_PROC1;
  end
  SS_PROC1: begin //3 
    ss_state_next = SS_PROC;
  end
  SS_PROC: begin //4
    if (tap_A == tap_A_max && mode_state == SM_MODE) begin
      ss_state_next = SS_HOLD;
    end else if (tap_A == tap_A_max) begin
      ss_state_next = SS_DONE;
    end else begin
      ss_state_next = SS_PROC;
    end
  end
  SS_HOLD: begin //5
    if (sm_tvalid & sm_tready) begin
      ss_state_next = SS_DONE;
    end else begin
      ss_state_next = SS_HOLD;
    end
  end
  default : begin
    ss_state_next = SS_IDLE;
  end
    
  endcase
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ss_state <= SS_IDLE;
  end else if (ap_state == AP_DONE) begin 
    ss_state <= SS_IDLE;
  end else begin
    ss_state <= ss_state_next;
  end
end

always @(*) begin
  ss_tready = (ss_state == SS_DONE)? 1 : 0;
end

//-----count data process -----//
always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      data_cnt <= 32'd0;
    end else if (ap_state == AP_INIT) begin
      data_cnt <= 32'h0;
    end 
    // else if (sm_state == SM_DONE) begin
    //   data_cnt <= data_cnt_next; //if transfer data, data_cnt+1
    // end 
    else if (sm_tvalid & sm_tready) begin
      data_cnt <= data_cnt_next; //if transfer data, data_cnt+1
    end  else begin
      data_cnt <= data_cnt;
    end
end
assign data_cnt_next = (data_cnt == data_length)? 0 : (data_cnt + 32'b1);

//-----AXI Stream out-----//
//assign sm_tvalid = (ss_state == 0 && data_cnt != 32'h1)? 1 : 0;
//-----FSM of sm-----//

always @(*) begin
  case (sm_state)
  SM_IDLE: begin//0
    if (tap_A == tap_A_max && ap_ctrl == 3'b001) begin
      sm_state_next = SM_WAIT1; 
    end else begin
      sm_state_next = SM_IDLE;
    end
  end
  SM_WAIT1: begin//1
    sm_state_next = SM_WAIT2;
  end
  SM_WAIT2: begin//2
    sm_state_next = SM_DONE;
  end
  SM_DONE: begin//3
    if (sm_tvalid & sm_tready) begin
      sm_state_next = SM_IDLE;
    end else begin
      sm_state_next = SM_LATCH;
    end
  end
  SM_LATCH: begin
    if (sm_tvalid & sm_tready) begin
      sm_state_next = SM_IDLE;
    end else begin
      sm_state_next = SM_LATCH;
    end
  end
  default: begin
    sm_state_next = SM_IDLE;
  end
  endcase
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    sm_state <= SM_IDLE;
  end else begin
    sm_state <= sm_state_next;
  end
end

assign sm_tvalid = (sm_state == SM_DONE | sm_state == SM_LATCH)? 1 : 0;
assign sm_tdata = ((sm_state == SM_DONE))? y : y_latch;
assign sm_tlast = (data_cnt == data_length)? 1 : 0;
//since data_cnt count how many ss_tready(how many Xn input)

//-----FSM of output latch-----//


assign y_latch_en = ((mode_state == SS_MODE && sm_state == SM_DONE) | (mode_state == SM_MODE && sm_tvalid & sm_tready))? 1 : 0;//latch enable
always @(*) begin
  if (y_latch_en == 1) begin
    y_latch_next = y;
  end else begin
    y_latch_next = y_latch; //remain y
  end
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    y_latch <= 0;
  end else begin
    y_latch <= y_latch_next;
  end
end

//-----FSM of operation MODE-----//

always @(*) begin
  case (mode_state)
  SS_MODE: begin
    if (sm_state == SM_LATCH) begin
      mode_state_next = SM_MODE;
    end else begin
      mode_state_next = SS_MODE;
    end
  end
  SM_MODE: begin
    if (ap_ctrl == 3'b100) begin
      mode_state_next = SS_MODE;
    end else begin
      mode_state_next = SM_MODE;
    end
  end
  endcase
end
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    mode_state <= SS_MODE;
  end else begin
    mode_state <= mode_state_next;
  end
end
endmodule