module top(input clk, output [`LEDS_NR-1:0] led);

reg [25:0] ctr_q;
wire [25:0] ctr_d;

always @(posedge clk)
	ctr_q <= ctr_d;

assign ctr_d = ctr_q + 1'b1;
assign led = ctr_q[25:25-(`LEDS_NR - 1)];

endmodule
