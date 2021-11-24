/* verilator lint_off DECLFILENAME */
/* verilator lint_off UNOPTFLAT */
`default_nettype none
module bitonic4(input wire clk, 
                input wire[31:0] din[0:WIDTH-1],
                output logic[31:0] dout[0:WIDTH-1]);
  localparam LOG_WIDTH = 2;
  localparam WIDTH = 4;
  logic[31:0] tmp[0:1][0:WIDTH-1];

  block_py#(LOG_WIDTH, .LOG_PY_WIDTH(1)) py0(.din(din), .dout(tmp[0]));
  block_py#(LOG_WIDTH, .LOG_PY_WIDTH(2)) py1(.din(tmp[0]), .dout(tmp[1]));
  block_st_reg#(LOG_WIDTH, .LOG_ST_WIDTH(1)) st0(.clk(clk),
                                                 .din(tmp[1]), .dout(dout));
endmodule
`default_nettype wire

`default_nettype none
module cmp(input wire[31:0] ain,
           input wire[31:0] bin,
           output logic[31:0] aout,
           output logic[31:0] bout);
  always_comb begin
    aout = ain > bin ? ain : bin;
    bout = ain > bin ? bin : ain;
  end
endmodule
`default_nettype wire

`default_nettype none
module pyramid#(parameter LOG_WIDTH=1)
               (input wire[31:0] din[0:WIDTH-1],
                output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;

  genvar i;
  generate
  for (i = 0; i < WIDTH/2; i++) begin
    cmp c(.ain(din[i]), .bin(din[WIDTH-1-i]),
          .aout(dout[i]), .bout(dout[WIDTH-1-i]));
  end
  endgenerate
endmodule
`default_nettype wire

`default_nettype none
module stairs#(parameter LOG_WIDTH=1)
              (input wire[31:0] din[0:WIDTH-1],
               output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;

  genvar i;
  generate
  for (i = 0; i < WIDTH/2; i++) begin
    cmp c(.ain(din[i]), .bin(din[WIDTH/2+i]),
          .aout(dout[i]), .bout(dout[WIDTH/2+i]));
  end
  endgenerate
endmodule
`default_nettype wire

`default_nettype wire
module block_py#(parameter LOG_WIDTH=1, parameter LOG_PY_WIDTH=1)
                (input wire[31:0] din[0:WIDTH-1],
                 output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;
  localparam PY_WIDTH = 2**LOG_PY_WIDTH;
  localparam NBLOCK = WIDTH/PY_WIDTH;

  genvar i;
  generate
  for (i = 0; i < NBLOCK; i++) begin
    pyramid#(LOG_PY_WIDTH) py(.din(din[i*PY_WIDTH:(i+1)*PY_WIDTH-1]),
                              .dout(dout[i*PY_WIDTH:(i+1)*PY_WIDTH-1]));
  end
  endgenerate
endmodule
`default_nettype none

`default_nettype wire
module block_py_reg#(parameter LOG_WIDTH=1, parameter LOG_PY_WIDTH=1)
                    (input wire clk,
                     input wire[31:0] din[0:WIDTH-1],
                     output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;
  localparam PY_WIDTH = 2**LOG_PY_WIDTH;
  localparam NBLOCK = WIDTH/PY_WIDTH;

  logic[31:0] tmp[0:WIDTH-1];
  block_py#(LOG_WIDTH, LOG_PY_WIDTH) py(.din(din), .dout(tmp));

  always_ff @(posedge clk) begin
    dout <= tmp;
  end
endmodule
`default_nettype none

`default_nettype wire
module block_st#(parameter LOG_WIDTH=1, parameter LOG_ST_WIDTH=1)
                (input wire[31:0] din[0:WIDTH-1],
                 output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;
  localparam ST_WIDTH = 2**LOG_ST_WIDTH;
  localparam NBLOCK = WIDTH/ST_WIDTH;

  genvar i;
  generate
  for (i = 0; i < NBLOCK; i++) begin
    stairs#(LOG_ST_WIDTH) py(.din(din[i*ST_WIDTH:(i+1)*ST_WIDTH-1]),
                             .dout(dout[i*ST_WIDTH:(i+1)*ST_WIDTH-1]));
  end
  endgenerate
endmodule
`default_nettype none

`default_nettype wire
module block_st_reg#(parameter LOG_WIDTH=1, parameter LOG_ST_WIDTH=1)
                    (input wire clk,
                     input wire[31:0] din[0:WIDTH-1],
                     output logic[31:0] dout[0:WIDTH-1]);
  localparam WIDTH = 2**LOG_WIDTH;
  localparam ST_WIDTH = 2**LOG_ST_WIDTH;
  localparam NBLOCK = WIDTH/ST_WIDTH;

  logic[31:0] tmp[0:WIDTH-1];
  block_st#(LOG_WIDTH, LOG_ST_WIDTH) py(.din(din), .dout(tmp));

  always_ff @(posedge clk) begin
    dout <= tmp;
  end
endmodule
`default_nettype none

/* verilator lint_on DECLFILENAME */
/* verilator lint_on UNOPTFLAT */

