interface axi_bus_if(input logic clk, input logic rst);
  logic [`AXI_ADDR_W-1:0] AWADDR;
  logic [2:0] AWPROT;
  logic AWVALID, AWREADY;
  logic [`AXI_DATA_W-1:0] WDATA;
  logic [(`AXI_DATA_W/8)-1:0] WSTRB;
  logic WVALID, WREADY;
  logic [1:0] BRESP;
  logic BVALID, BREADY;
  logic [`AXI_ADDR_W-1:0] ARADDR;
  logic [2:0] ARPROT;
  logic ARVALID, ARREADY;
  logic [`AXI_DATA_W-1:0] RDATA;
  logic [1:0] RRESP;
  logic RVALID, RREADY;

  clocking cb_drv @(posedge clk);
    default input #1 output #1;
    output AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY,
           ARADDR, ARPROT, ARVALID, RREADY;
    input AWREADY, WREADY, BVALID, ARREADY, RVALID;
  endclocking

  clocking cb_mon @(posedge clk);
    default input #1 output #1;
    input rst, AWADDR, AWPROT, AWVALID, WDATA, WSTRB, WVALID, BREADY,
          ARADDR, ARPROT, ARVALID, RREADY, AWREADY, WREADY, BRESP,
          BVALID, ARREADY, RDATA, RRESP, RVALID;
  endclocking

  modport DRV(clocking cb_drv);
  modport MON(clocking cb_mon);
endinterface
