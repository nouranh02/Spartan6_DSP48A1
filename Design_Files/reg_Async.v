module reg_Async(clk, rst, CE, D, Q);
	parameter WIDTH = 1;
	input clk, rst, CE;
	input [WIDTH-1:0] D;
	output reg [WIDTH-1:0] Q;

	always @(posedge clk or posedge rst) begin
		if(rst) Q <= 0;
		else if(CE) Q <= D;
	end
endmodule