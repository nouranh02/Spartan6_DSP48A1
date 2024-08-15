// dsp test bench , inverse parameters
module dsp_tb (); // default parameters

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

 

  reg CLK, CARRYIN;
  reg RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;
  reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
  reg [17:0] A, B, BCIN, D;
  reg [47:0] C, PCIN;
  reg [7:0] OPMODE;

  wire[17:0] BCOUT;
  wire [47:0] PCOUT;
  wire [47:0] P;
  wire [35:0] M;
  wire CARRYOUT;
  wire CARRYOUTF;

  reg [17:0] ex_BCOUT;
  reg [47:0] ex_P;
  reg [35:0] ex_M;
  reg ex_CARRYOUT;


  // temporary wires 
  reg [17:0] t_pre;
  reg [47:0] t_post;
  reg [35:0] t_multi; 
  reg [47:0] t_multi_ext;



DSP48A1 dut (CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE
        , CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE
        , A, B, BCIN, D, C, PCIN, OPMODE, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

initial begin 
CLK=0;
forever
#1 CLK=~CLK;
end

integer i;

initial begin
// reset inputs
  RSTA=1;
  RSTB=1;
  RSTM=1;
  RSTP=1;
  RSTC=1;
  RSTD=1;
  RSTCARRYIN=1; 
  RSTOPMODE=1;
// control enable inputs
  CEA=1;
  CEB=1;
  CEM=1; 
  CEP=1; 
  CEC=1; 
  CED=1; 
  CECARRYIN=1; 
  CEOPMODE=1;
// data inputs
  CARRYIN=1'b0;
  A=18'b0; 
  B=18'b0; 
  D=18'b0; 
  C=48'b0;
  BCIN=18'b0;  
  PCIN=48'b0; 
// opmode
  OPMODE=8'b0000_00_00;
  #30;
  // unreset inputs
  RSTA=0;
  RSTB=0;
  RSTM=0;
  RSTP=0;
  RSTC=0;
  RSTD=0;
  RSTCARRYIN=0; 
  RSTOPMODE=0;
  #10;
//8'b post-add_pre-add_carry-cascade_B1-REG-input_Z-Multiplexer_X-Multiplexer;

//////////////////////////////// first mode
for(i=0;i<10;i=i+1)begin
OPMODE = 8'b0001_11_01; // post-addition,per-addition,zero-carry,use-pre-add,use-c,use-multi
// data inputs
CARRYIN=1'b1;
  A=$random; 
  B=$random;
  D=$random;
  C=$random; 
  BCIN=$random;
  PCIN=$random;
// getting expected output
t_pre = D+B;
t_multi = t_pre*A;
t_multi_ext={{12{t_multi[35]}},t_multi};
{ex_CARRYOUT,t_post} = C+(OPMODE[5]+t_multi_ext);
ex_P=t_post;
ex_M=t_multi_ext;
ex_BCOUT=t_pre;
#20;
// Comparison
if(BCOUT!=ex_BCOUT)begin
$display("error BCOUT");
$stop;
end
if(P!=ex_P)begin
$display("error P");
$stop;
end
if(M!=ex_M)begin
$display("error M");
$stop;
end
if(CARRYOUT!=ex_CARRYOUT)begin
$display("error CARRYOUT");
$stop;
end
end


//////////////////////////////// second mode
for(i=0;i<10;i=i+1)begin

OPMODE = 8'b1111_11_01; // post-subtraction,per-subtraction,zero-carry,use-pre-add,use-c,use-multi
// data inputs
CARRYIN=1'b1;
  A=$random; 
  B=$random;
  D=$random; 
  C=$random; 
  BCIN=$random;
  PCIN=$random;
// getting expected output
t_pre = D-B;
t_multi = t_pre*A;
t_multi_ext={{12{t_multi[35]}},t_multi};
{ex_CARRYOUT,t_post} = C-(OPMODE[5]+t_multi_ext);
ex_P=t_post;
ex_M=t_multi_ext;
ex_BCOUT=t_pre;
#20;
// Comparison
if(BCOUT!=ex_BCOUT)begin
$display("error BCOUT");
$stop;
end
if(P!=ex_P)begin
$display("error P");
$stop;
end
if(M!=ex_M)begin
$display("error M");
$stop;
end
if(CARRYOUT!=ex_CARRYOUT)begin
$display("error CARRYOUT");
$stop;
end
end


//////////////////////////////// third mode
for(i=0;i<10;i=i+1)begin

OPMODE = 8'b0001_01_00; 
// data inputs
CARRYIN=1'b1;
  A=$random; 
  B=$random;
  D=$random; 
  C=$random; 
  BCIN=$random;  
  PCIN=$random;
// getting expected output
t_pre = D+B;
t_multi = t_pre*A;
t_multi_ext={{12{t_multi[35]}},t_multi};
{ex_CARRYOUT,t_post} = PCIN+0;
ex_P=PCIN;
ex_M=t_multi_ext;
ex_BCOUT=t_pre;
#20;
// Comparison
if(BCOUT!=ex_BCOUT)begin
$display("error BCOUT");
$stop;
end
if(P!=ex_P)begin
$display("error P");
$stop;
end
if(M!=ex_M)begin
$display("error M");
$stop;
end
if(CARRYOUT!=ex_CARRYOUT)begin
$display("error CARRYOUT");
$stop;
end
end


//////////////////////////////// fourth mode
for(i=0;i<10;i=i+1)begin

OPMODE = 8'b0000_00_01; 
// data inputs
CARRYIN=1'b1;
  A=$random; 
  B=$random;
  D=$random; 
  C=$random; 
  BCIN=$random; 
  PCIN=$random;
// getting expected output
t_multi = B*A;
t_multi_ext={{12{t_multi[35]}},t_multi};
{ex_CARRYOUT,t_post} = t_multi_ext+0;
ex_P=t_post;
ex_M=t_multi_ext;
ex_BCOUT=B;
#20;
// Comparison
if(BCOUT!=ex_BCOUT)begin
$display("error BCOUT");
$stop;
end
if(P!=ex_P)begin
$display("error P");
$stop;
end
if(M!=ex_M)begin
$display("error M");
$stop;
end
if(CARRYOUT!=ex_CARRYOUT)begin
$display("error CARRYOUT");
$stop;
end
end


//////////////////////////////// fifth mode

for(i=0;i<10;i=i+1)begin

OPMODE = 8'b0000_10_11; 


// data inputs
CARRYIN=1'b1;
  A=$random; 
  B=$random;
  D=$random; 
  C=$random; 
  BCIN=$random; 
  PCIN=$random;
#20;
end


//////////////////////////////// sixth mode

for(i=0;i<10;i=i+1)begin

OPMODE = 8'b0001_11_10; 
CARRYIN=1'b1;


  A=$random; 
  B=$random;
  D=$random; 
  C=$random; 
  BCIN=$random; 
  PCIN=$random;
#20;
end

#2 $stop;
end
endmodule

