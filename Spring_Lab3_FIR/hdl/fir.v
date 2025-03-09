 //first pass version
 `define AP_INIT 2'b00
 `define AP_START 2'b01
 `define AP_DONE 2'b10

 `define SS_WRITE 1'b0
 `define SS_PROC 1'b1

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
    output  wire [(pDATA_WIDTH-1):0] rdata,   //replace to wire
//-----AXI Stream, input data Xn-----//
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  reg                     ss_tready, 
    input   wire                     sm_tready, 
    output  reg                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast, 
    
    // bram for tap RAM
    output  wire [3:0]               tap_WE, //replace to wire
    output  wire                     tap_EN, //replace to wire
    output  wire [(pDATA_WIDTH-1):0] tap_Di, //replace to wire
    output  wire [(pADDR_WIDTH-1):0] tap_A,  
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

//-----AXI Lite write-----//
reg AWREADY;
reg WREADY;
//-----AXI Lite read-----//
reg ARREADY;
reg RVALID;
//-----Tap_RAM (AXI Lite)-----//
reg [(pADDR_WIDTH-1) : 0] tap_A_tmp;
//-----configuration register: data_length (AXI Lite)-----//
//-----address 0x10-----//
reg [(pDATA_WIDTH-1) : 0] data_length;
wire [(pDATA_WIDTH-1) : 0] data_length_next;
wire [(pDATA_WIDTH-1) : 0] data_length_in;
wire data_length_ctrl;
//-----configuration register: coef_length (AXI Lite)-----//
//-----address 0x14-----//
reg [(pDATA_WIDTH-1) : 0] coef_length;
wire [(pDATA_WIDTH-1) : 0] coef_length_next;
wire [(pDATA_WIDTH-1) : 0] coef_length_in;
wire coef_length_ctrl;
//-----configuration register: ap_ctrl (AXI Lite)-----//
reg [2 : 0] ap_ctrl;
wire [2 : 0] ap_ctrl_next;
wire [2 : 0] ap_ctrl_in;
wire ap_ctrl_ctrl;
//-----FSM of fir-----//
reg [1:0] ap_state;
reg [1:0] ap_state_next;
reg [2 : 0] ap_ctrl_fir;
//-----tap RAM address generator 0x40-0xFF-----//
reg [(pADDR_WIDTH-1) : 0] tap_addr_generator;
wire [(pADDR_WIDTH-1) : 0] tap_addr_generator_next;
wire [(pADDR_WIDTH-1) : 0] tap_addr_max;
//count data process 
reg [(pDATA_WIDTH-1) : 0] data_cnt; // count how many data have been process.
wire [(pDATA_WIDTH-1) : 0] data_cnt_next; // cnt = 600, state = done
wire [(pADDR_WIDTH-1) : 0] tap_A_max;
wire [(pADDR_WIDTH-1) : 0] addr_max;
//-----data RAM address generator 0x40-0xFF-----//
//1. axi_stream: write adress generate(FIFO, write data_RAM)
reg [(pADDR_WIDTH-1):0] data_addr_w;
wire [(pADDR_WIDTH-1):0] data_addr_w_next;
//2. axi_stream: read address generate
reg [(pADDR_WIDTH-1) : 0] data_addr_r;
wire [(pADDR_WIDTH-1) : 0] data_addr_r_next;
//-----core engine-----//
wire [(pDATA_WIDTH-1) : 0] data_x;
wire [(pDATA_WIDTH-1) : 0] tap_h;
wire [(pDATA_WIDTH-1) : 0] x_mul_h_next;
wire [(pDATA_WIDTH-1) : 0] y_next;
reg [(pDATA_WIDTH-1) : 0] x_mul_h;
reg [(pDATA_WIDTH-1) : 0] y;
//-----FSM of ss-----//
reg ss_state;
reg ss_state_next;

//response awready, wready signal to task: config_write(addr, data)
//response arready, rvalid signal to task: config_read_check(addr, exp_data, mask)
always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
        //-----AXI Lite write-----//
        AWREADY <= 0;
        WREADY <= 0;
        //-----AXI Lite read-----//
        ARREADY <= 0;
        RVALID <= 0;
    end else begin
        //-----AXI Lite write-----//
        AWREADY <= awvalid && wvalid; //to delay the signal from tb, match the synthesis
        WREADY <= wvalid && awvalid;
        //-----AXI Lite read-----//
        ARREADY <= arvalid && rready; //buffer
        RVALID <= rready && arvalid;
    end
end

//-----AXI Lite write-----//
assign awready = (AWREADY && awvalid)? 1 : 0;
assign wready = (WREADY && wvalid)? 1 : 0;
//-----AXI LIte read-----//
assign arready = (arvalid && ARREADY)? 1 : 0;
assign rvalid = (rready && RVALID)? 1 : 0;

//-----Tap_RAM (AXI Lite)-----//
//-----address 0x40-0xFF-----//
always @(*) begin
    case ({awvalid, arvalid})
    2'b10: begin //addr for write
    //if awaddr = 12'h10=>(data length reg)
    //if awaddr = 12'h14=>(coef length reg)
      tap_A_tmp = (awaddr != 12'h10 && awaddr != 12'h14)? awaddr[6:0]: 0;
    end
    2'b01: begin //addr for read
      tap_A_tmp = araddr[6:0];
    end
    default: begin
      tap_A_tmp = 0;
    end  
    endcase
end
//ap_ctrl = 4: idle, ap_ctrl = 1: start
assign tap_A = (ap_ctrl == 3'b100)? tap_A_tmp : ((ap_ctrl == 3'b001)? tap_addr_generator[6:0] : 0);
assign tap_Di = wdata;
assign tap_EN = 1;
assign tap_WE = (wvalid && wready && (ap_ctrl == 3'b100))? 4'b1111 : 4'b0000; // handshake: wvalid && wready
assign rdata = (rvalid && rready)? ((araddr != 32'h00)? tap_Do : ap_ctrl) : 0; //handshake: rvalid = rvalid && rready

//-----configuration register: data_length (AXI Lite)-----//
//-----address 0x10-----//
assign data_length_in = (wvalid && wready)? wdata : 0; //write handshake
assign data_length_ctrl = (awaddr == 12'h10)? 1 : 0;
assign data_length_next = (data_length_ctrl == 1)? data_length_in : data_length;

always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      data_length <= 32'h0;
    end else begin
      data_length <= data_length_next;
    end
end

//-----configuration register: coef_length (AXI Lite)-----//
//-----address 0x14-----//
assign coef_length_in = (wvalid && wready)? wdata : 0; //write handshake
assign coef_length_ctrl = (awaddr == 12'h14)? 1 : 0;
assign coef_length_next = (coef_length_ctrl == 1)? coef_length_in : coef_length;

always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      coef_length <= 32'h0;
    end else begin
      coef_length <= coef_length_next;
    end
end

//-----configuration register: ap_ctrl (AXI Lite)-----//
//-----ap_ctrl can use AXI Lite to write, or decided by fir FSM-----//
//ap_ctrl[2]: idle, ap_ctrl[1]: done, ap_ctrl[0]: start
assign ap_ctrl_in = (wvalid && wready)? wdata : 0; //write handshake
assign ap_ctrl_ctrl = (awaddr == 12'h00 && wready)? 1 : 0; //axi_lite write 0x00

//since awaddr = 00 after the last axilite write(program start), we can't only
//use awaddr = 12'h00 as condition, else (awaddr = 12'h00) will
//always be true
assign ap_ctrl_next = (ap_ctrl_ctrl == 1)? ap_ctrl_in : ap_ctrl_fir; 
//if awaddr != 12'h00, use fir state to determine ap_ctrl.
always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      ap_ctrl <= 3'b100; //ap_idle
    end else begin
      ap_ctrl <= ap_ctrl_next;  //program by tb
    end
end

//-----FSM of fir-----//
always @(*) begin
  case (ap_state)
  `AP_INIT: begin //00
    if (awaddr == 12'h00 && wdata == 32'h0000_0001 && wvalid == 1) begin
      //program start
      ap_state_next = `AP_START;
      ap_ctrl_fir = 3'b101;
    end else begin
      ap_state_next = `AP_INIT;
      ap_ctrl_fir = 3'b100;
    end
  end
  `AP_START: begin //01
    if (sm_tlast == 1 && ss_tlast == 1) begin
      ap_state_next = `AP_DONE;
      ap_ctrl_fir = 3'b010;
    end else begin
      ap_state_next = `AP_START;
      ap_ctrl_fir = 3'b001;
    end
  end
  `AP_DONE: begin //10
    if (araddr == 12'h0 && rvalid == 1) begin
      ap_state_next = `AP_INIT;
      ap_ctrl_fir = 3'b100;
    end else begin
      ap_state_next = `AP_DONE;
      ap_ctrl_fir = 3'b010;
    end
  end
  default: begin
    ap_state_next = `AP_INIT;
    ap_ctrl_fir = 3'b100;
  end
  endcase
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ap_state <= `AP_INIT;
  end else begin
    ap_state <= ap_state_next;
  end
end

//-----tap RAM address generator 0x40-0xFF-----//
//tap RAM write/read coeff whan state = idle
//if calculation, the tap RAM address should produce with address generator
assign  tap_addr_max = 12'h80 + 4 * (coef_length - 1);
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    tap_addr_generator <= 12'h80;
  end else if (tap_addr_generator == tap_addr_max | ap_ctrl == 3'b101 | ap_ctrl == 3'b100 | ss_tready == 1) begin
    tap_addr_generator <= 12'h80;
  end else begin
    tap_addr_generator <= tap_addr_generator_next; 
  end
end
assign tap_addr_generator_next = tap_addr_generator + 12'h4;

//-----AXI Stream-----//
//ss_tready can be 1 if it's not idle or done.
//ss_tready = 1 if ap_ctrl = 32'h5(idle->start), or tap_A = 12'h28(11-tap)
//tap_A = 12'd(0+coef_length-1)*4 (last 6 bit)
//1. control ss_tready 
//if idle, write 0 in dataRAM
assign data_WE = ((ss_tready && ss_tvalid) | ap_ctrl == 3'b100)? 4'b1111 : 4'b0000; //handshake: ss_tready = ss_tready && ss_tvalid
assign data_EN = 1;
assign data_Di = (ap_ctrl == 3'b100 )? 0 : ss_tdata;
//when BRAM getting address, it will access(r/w) memory in next clock.
assign data_A = (ap_ctrl == 3'b100)? tap_A : (ss_tready && ss_tvalid) ? data_addr_w[6:0] : data_addr_r[6:0]; //generate by address generator

//-----count data process -----//
assign tap_A_max = (coef_length - 1) * 4; //address for bram
assign addr_max = 12'h80 + (coef_length - 1) * 4;

always @(posedge axis_clk or negedge axis_rst_n) begin
    if (!axis_rst_n) begin
      ss_tready <= 0;
      data_cnt <= 32'd0;
    end else if ((ap_ctrl == 3'b101 | tap_A == tap_A_max) && (ap_ctrl != 3'b100) && (ap_ctrl != 3'b010)) begin
      ss_tready <= 1; //can ready only if fir state = start.
      data_cnt <= data_cnt_next; //if transfer data, data_cnt+1
    end else begin
      ss_tready <= 0;
      data_cnt <= data_cnt;
    end
end
assign data_cnt_next = (data_cnt == data_length)? 0 : (data_cnt + 32'b1);

//-----data RAM address generator 0x40-0xFF-----//
//1. axi_stream: write adress generate(FIFO, write data_RAM)
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    data_addr_w <= 12'h80;
  end else if ((ss_tready && ss_tvalid) == 1) begin
    data_addr_w <= data_addr_w_next; //+4
  end else begin
    data_addr_w <= data_addr_w; //maintain
  end
end
//refresh data_addr_w in each ss_tready
//write until bram is full(coeff_length)
assign  data_addr_w_next = (data_addr_w != addr_max)? data_addr_w + 12'h4 : 12'h80;

//2. axi_stream: read address generate
//need a counter(dara_cnt) to count how many data we process.
//Note: if (data_cnt == data_length) then ap_state = AP_DONE
// the data_cnt will also affect the data_addr_r

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    data_addr_r <= 12'h80;
  end else if (ap_ctrl == 3'b100) begin 
    data_addr_r <= 12'h80;
  end else if ((ss_tready && ss_tvalid) == 1) begin
    data_addr_r <= data_addr_w;
  end else begin
    data_addr_r <= data_addr_r_next;
  end
end
//if read to addr 12'h80, switch to the end of bram addr
assign data_addr_r_next = (data_addr_r == 12'h80)? 12'h80 + (coef_length - 1) * 4 : data_addr_r - 12'h4;

//-----core engine-----//
//if ss_state = 0, writing, dont load data
assign data_x = (ss_state == `SS_PROC)? data_Do : 0;
assign tap_h = (ss_state == `SS_PROC)? tap_Do : 0;
assign x_mul_h_next = data_x * tap_h;
assign y_next = x_mul_h + y;

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    y <= 0;
    x_mul_h <= x_mul_h_next;
  end else if (ap_ctrl == 3'b001 && (sm_tvalid && sm_tready) == 1) begin
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
  `SS_WRITE: begin
    if ((ss_tready && ss_tvalid) == 1) begin
      ss_state_next = `SS_WRITE;
    end else begin
      ss_state_next = `SS_PROC;
    end
  end
  `SS_PROC: begin
    if (ss_tready == 1) begin
      ss_state_next = `SS_WRITE;
    end else begin
      ss_state_next = `SS_PROC;
    end
  end
  endcase
end

always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    ss_state <= `SS_PROC;
  end else begin
    ss_state <= ss_state_next;
  end
end

//-----AXI Stream out-----//
//assign sm_tvalid = (ss_state == 0 && data_cnt != 32'h1)? 1 : 0;
always @(posedge axis_clk or negedge axis_rst_n) begin
  if (!axis_rst_n) begin
    sm_tvalid <= 0;
  end else if (data_cnt == 32'h1) begin 
    sm_tvalid <= 0;
  end else if (ss_state == `SS_WRITE) begin
    sm_tvalid <= 1;
  end else begin
    sm_tvalid <= 0;
  end
end

assign sm_tdata = ((sm_tvalid && sm_tready))? y : 0;
assign sm_tlast = ((ss_state == `SS_WRITE) && (data_cnt == 32'd0))? 1 : 0;
//since data_cnt count how many ss_tready(how many Xn input)

endmodule