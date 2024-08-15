module buffer(clk, D, Q);
	parameter WIDTH = 1;
	input clk;
	input [WIDTH-1:0] D;
	output reg [WIDTH-1:0] Q;

	always @(posedge clk) begin
		Q <= D;
	end
endmodule