module reg_Sync(clk, rst, CE, D, Q);
	parameter WIDTH = 1;
	input clk, rst, CE;
	input [WIDTH-1:0] D;
	output reg [WIDTH-1:0] Q;

	always @(posedge clk) begin
		if(rst) Q <= 0;
		else if(CE) Q <= D;
	end
endmodule