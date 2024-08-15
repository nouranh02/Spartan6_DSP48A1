module DSP48A1(CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE
				, CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE
				, A, B, BCIN, D, C, PCIN, OPMODE, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

	parameter A0REG = 0;
	parameter A1REG = 1;
	parameter B0REG = 0;
	parameter B1REG = 1;
	parameter CREG = 1;
	parameter DREG = 1;
	parameter MREG = 1;
	parameter PREG = 1;
	parameter CARRYINREG = 1;
	parameter CARRYOUTREG = 1;
	parameter OPMODEREG = 1;
	parameter CARRYINSEL = "OPMODE5";
	parameter B_INPUT = "DIRECT";
	parameter RSTTYPE = "SYNC";

	input CLK, CARRYIN;
	input RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;
	input CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
	input [17:0] A, B, BCIN, D;
	input [47:0] C, PCIN;
	input [7:0] OPMODE;

	output [17:0] BCOUT;
	output [47:0] PCOUT;
	output [47:0] P;
	output [35:0] M;
	output CARRYOUT;
	output CARRYOUTF;

	reg [17:0] B0reg_in, pre_out, B1reg_in;
	wire [17:0] Dreg_out, B0reg_out, A0reg_out, B1reg_out, A1reg_out, Dmux_out, B0mux_out, A0mux_out, B1mux_out, A1mux_out;
	wire [35:0] mult_out, Mreg_out, Mmux_out;
	reg [47:0] X_out, Z_out, post_out;
	wire [47:0] Creg_out, Cmux_out, Preg_out;
	wire [7:0] OPMODEreg_out, OPMODE_out;
	reg carrycsc_out, post_carryout;
	wire CYI_out, CIN, CYO_out;
	wire [47:0] D_A_B;
	
	generate
		if(RSTTYPE == "SYNC") begin
			reg_Sync #(8) OPMODEreg_sync(CLK, RSTOPMODE, CEOPMODE, OPMODE, OPMODEreg_out);
			reg_Sync #(18) Dreg_sync(CLK, RSTD, CED, D, Dreg_out);
			reg_Sync #(18) B0reg_sync(CLK, RSTB, CEB, B0reg_in, B0reg_out);
			reg_Sync #(18) A0reg_sync(CLK, RSTA, CEA, A, A0reg_out);
			reg_Sync #(48) Creg_sync(CLK, RSTC, CEC, C, Creg_out);
			reg_Sync #(18) B1reg_sync(CLK, RSTB, CEB, B1reg_in, B1reg_out);
			reg_Sync #(18) A1reg_sync(CLK, RSTA, CEA, A0mux_out, A1reg_out);
			reg_Sync #(36) Mreg_sync(CLK, RSTM, CEM, mult_out, Mreg_out);
			reg_Sync #(1) CARRYINreg_sync(CLK, RSTCARRYIN, CECARRYIN, carrycsc_out, CYI_out);
			reg_Sync #(1) CARRYOUTreg_sync(CLK, RSTCARRYIN, CECARRYIN, post_carryout, CYO_out);
			reg_Sync #(48) Preg_sync(CLK, RSTP, CEP, post_out, Preg_out);
		end
		else if(RSTTYPE == "ASYNC") begin
			reg_Async #(8) OPMODEreg_async(CLK, RSTOPMODE, CEOPMODE, OPMODE, OPMODEreg_out);
			reg_Async #(18) Dreg_async(CLK, RSTD, CED, D, Dreg_out);
			reg_Async #(18) B0reg_async(CLK, RSTB, CEB, B0reg_in, B0reg_out);
			reg_Async #(18) A0reg_async(CLK, RSTA, CEA, A, A0reg_out);
			reg_Async #(48) Creg_async(CLK, RSTC, CEC, C, Creg_out);
			reg_Async #(18) B1reg_async(CLK, RSTB, CEB, B1reg_in, B1reg_out);
			reg_Async #(18) A1reg_async(CLK, RSTA, CEA, A0mux_out, A1reg_out);
			reg_Async #(36) Mreg_async(CLK, RSTM, CEM, mult_out, Mreg_out);
			reg_Async #(1) CARRYINreg_async(CLK, RSTCARRYIN, CECARRYIN, carrycsc_out, CYI_out);
			reg_Async #(1) CARRYOUTreg_async(CLK, RSTCARRYIN, CECARRYIN, post_carryout, CYO_out);
			reg_Async #(48) Preg_async(CLK, RSTP, CEP, post_out, Preg_out);
		end

	endgenerate

	//Internal Signals
	assign OPMODE_out = (OPMODEREG) ? OPMODEreg_out : OPMODE;
	assign Dmux_out = (DREG) ? Dreg_out : D;
	assign B0mux_out = (B0REG) ? B0reg_out : B0reg_in;
	assign A0mux_out = (A0REG) ? A0reg_out : A;
	assign Cmux_out = (CREG) ? Creg_out : C;

	assign B1mux_out = (B1REG) ? B1reg_out : B1reg_in;
	assign A1mux_out = (A1REG) ? A1reg_out : A0mux_out;

	assign Mmux_out = (MREG) ? Mreg_out : mult_out;

	assign CIN = (CARRYINREG) ? CYI_out : carrycsc_out;

	assign D_A_B = {Dmux_out[11:0], A1mux_out[17:0], B1mux_out[17:0]};
	assign mult_out = B1mux_out * A1mux_out;

	//Outputs
	assign BCOUT = B1mux_out;
	buffer #(36) M_out(CLK, Mmux_out, M);
	assign CARRYOUT = (CARRYINREG) ? CYO_out : post_carryout;
	assign CARRYOUTF = CARRYOUT;
	assign P = (PREG) ? Preg_out : post_out;
	assign PCOUT = P;


	always @(*) begin
		//B_input
		if(B_INPUT == "DIRECT") B0reg_in = B;
		else if(B_INPUT == "CASCADE") B0reg_in = BCIN;
		else B0reg_in = 0;

		//Pre-Adder/Subtracter
		if(OPMODE_out[6]) pre_out = Dmux_out - B0mux_out;
		else pre_out = Dmux_out + B0mux_out;

		//B1_REG_input
		if(OPMODE_out[4]) B1reg_in = pre_out;
		else B1reg_in = B0mux_out;

		//Carry_Cascade
		if(CARRYINSEL == "OPMODE5") carrycsc_out = OPMODE_out[5];
		else if(CARRYINSEL == "CARRYIN") carrycsc_out = CARRYIN;
		else carrycsc_out = 0;

		//X_Multiplexer
		case(OPMODE_out[1:0])
		2'b00: X_out = 0;
		2'b01: X_out = {{12{Mmux_out[35]}}, Mmux_out};
		2'b10: X_out = P;
		2'b11: X_out = D_A_B;
		endcase

		//Z_Multiplexer
		case(OPMODE_out[3:2])
		2'b00: Z_out = 0;
		2'b01: Z_out = PCIN;
		2'b10: Z_out = P;
		2'b11: Z_out = Cmux_out;
		endcase

		//Post-Adder/Subtracter
		if(OPMODE_out[7]) {post_carryout, post_out} = Z_out - (X_out + CIN);
		else {post_carryout, post_out} = Z_out + X_out + CIN;
	end

endmodule