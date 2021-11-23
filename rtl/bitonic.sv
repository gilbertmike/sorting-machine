`default_nettype none
module bitonic#(parameter WIDTH=4)
               (input wire clk, 
                input wire[WIDTH-1:0] din,
                output logic[WIDTH-1:0] dout);
  always_ff @(posedge clk) begin
    dout <= din;
  end
endmodule
`default_nettype wire

