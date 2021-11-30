/* verilator lint_off DECLFILENAME */
/* verilator lint_off UNOPTFLAT */
`default_nettype none
module sorter(input wire clk, start,
              input wire[31:0] din[0:7],
              output logic[31:0] dout,
              output logic valid, done);
  localparam BITONIC_DELAY = 1, NUM_ITEMS = 8;
  logic[3:0] left;

  logic[31:0] b0_res[0:3], b1_res[0:3], b0_tmp[0:3], b1_tmp[0:3];
  bitonic4 b0(.clk(clk), .din(din[0:3]), .dout(b0_tmp));
  bitonic4 b1(.clk(clk), .din(din[4:7]), .dout(b1_tmp));

  always_ff @(posedge clk) begin
    if (start) begin
      valid <= 0;
      done <= 0;
      left <= NUM_ITEMS + BITONIC_DELAY;
    end else begin
      if (left == 0) begin
        valid <= 0;
        done <= 1;
      end else if (left == NUM_ITEMS + 1) begin
        b0_res <= b0_tmp;
        b1_res <= b1_tmp;
      end else if (left <= NUM_ITEMS) begin
        valid <= 1;
        if (b0_res[0] > b1_res[0]) begin
          dout <= b0_res[0];
          for (integer i = 0; i < 3; i++) begin
            b0_res[i] <= b0_res[i+1];
          end
          b0_res[3] <= 0;
        end else begin
          dout <= b1_res[0];
          for (integer i = 0; i < 3; i++) begin
            b1_res[i] <= b1_res[i+1];
          end
          b1_res[3] <= 0;
        end
      end
      left <= left > 0 ? left - 1 : 0;
    end
  end
endmodule
`default_nettype wire
/* verilator lint_on DECLFILENAME */
/* verilator lint_on UNOPTFLAT */

