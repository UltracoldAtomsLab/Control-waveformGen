module waveformGen(
	input        CLK_50,
	input        EXT_CLK,

	output       LED3,
	output       LED4,

	output [7:0] OUT1,
	output [7:0] OUT2,
	output [7:0] OUT3,

	inout [12:0] IN1,
	input [12:0] IN2,
	inout [7:0]  IN3,

	inout [10:0] EXT,

	input [3:0]  SW,

	input        USB_TXD,  // computer transmit
	output       USB_RXD,  // computer recieve

	output       ADDIN,
	output       ADCLK,
	output       ADCS,
	input        ADDOUT,

	output       DADATA,
	output       DACLK,
	output       DACS
);
`include "v/para.h"

wire               nRst;
reg  [7:0]         reset_count;
wire               m_cmd_reset;
reg                cmd_reset;
wire               Armed;
wire [7:0]         mMode;
wire               mFlagTimeReady;
wire               mFlagChValueReady;
wire [7:0]         mDataChannel;
wire [`bitNum-1:0] mDataTime;
wire               mDataChValue;
reg  [7:0]         Mode;
reg                FlagTimeReady;
reg                FlagChValueReady;
reg  [7:0]         DataChannel;
reg  [`bitNum-1:0] DataTime;
reg                DataChValue;
wire               TriggerLinein;
wire               TriggerOut;
wire [254:0]       Waveform;
reg                CLK_custom;
reg  [11:0]        clk_cnt, clk_cnt_max;
wire               CLK_custom_reset;
wire [7:0]         Test;
wire							 mFlagSplRateReady;
wire [7:0]				 mSplRate;

assign EXT[7:0] = Test;
assign LED4 = Armed;

assign OUT1 = Waveform[7:0];
assign OUT2 = Waveform[15:8];
assign OUT3[6:0] = Waveform[22:16];
assign OUT3[7] = CLK_custom;
// IN[0] and IN1[1] are used as outputs
//assign IN1[1]  = CLK_custom;
assign IN1[0]  = TriggerOut;

//assign TriggerLinein = IN3[0];
assign TriggerLinein = IN1[1];
assign IN3[1] = TriggerLinein;
assign nRst = (reset_count==0);


always @ (posedge CLK_50) begin
	if(reset_count != 7'h00)
		reset_count <= reset_count + 1'b1;
	else
		reset_count <= reset_count + cmd_reset;


	if(CLK_custom_reset) begin
		clk_cnt <= 12'd0;
		CLK_custom <= 1'b0;
	end
	else if(clk_cnt >= clk_cnt_max) begin
		clk_cnt <= 12'd0;
		CLK_custom <= ~CLK_custom;
	end
	else
		clk_cnt <= clk_cnt + 1'b1;
end

always @ (posedge mFlagSplRateReady)
begin
	clk_cnt_max <= (mSplRate*10-1'b1);
end



always @ (posedge CLK_50 or negedge nRst) begin
	if (!nRst)begin
		Mode          <= 8'h00;
		FlagTimeReady <= 1'b0;
		FlagChValueReady <= 1'b0;
		DataChannel   <= 8'h00;
		DataTime      <= `bitNum'h00000000;
		DataChValue   <= 1'b0;
		cmd_reset     <= 1'b0;
	end
	else begin
		cmd_reset        <= m_cmd_reset;
		Mode             <= mMode;
		FlagTimeReady    <= mFlagTimeReady;
		FlagChValueReady <= mFlagChValueReady;
		DataChannel      <= mDataChannel;
		DataTime         <= mDataTime;
		DataChValue      <= mDataChValue;
	end
end
RS232_CONTROL rs232_0(
	.iNRST(nRst),               // the reset signal
	.iCLK (CLK_50),             // the clock, 50M Hz
	.iRXD (USB_TXD),            // recieving channel from computer

	.oMode                  (mMode),
	.oMODE_SET_CH_WAVEFORM  (),
	.oMODE_SET_CH_INIT_VAL  (),
	.oMODE_SET_CH_VAL_FORCED(),
	.oMODE_SET_PERIOD       (),
	.oMODE_CMD_ARM          (),
	.oMODE_CMD_TO_INIT      (),
	.oMODE_CMD_RESET_TIME   (),
	.oMODE_CMD_RESET_DEV    (m_cmd_reset),

	.oFLAG_TIME_READY       (mFlagTimeReady),
	.oFLAG_CH_VAL_READY     (mFlagChValueReady),
	.oFLAG_SPL_RATE_READY		(mFlagSplRateReady),
	.oDATA_CHANNEL          (mDataChannel),
	.oDATA_TIME             (mDataTime),
	.oDATA_CH_VAL           (mDataChValue),
	.oSPL_RATE							(mSplRate),
);


SEQ_WAVE_GEN seq_wave_gen0(
	.iNRST    (nRst),
	.iCLK     (CLK_50), // 12.5M
	.iTRIG    (TriggerLinein),
	.iCTRL_MODE        (Mode),
	.iFLAG_TIME_READY  (FlagTimeReady),
	.iFLAG_CH_VAL_READY(FlagChValueReady),
	.iDATA_CHANNEL     (DataChannel),
	.iDATA_TIME        (DataTime),
	.iDATA_CH_VAL      (DataChValue),

	.oWAVEFORM (Waveform),
	.oTRIG_SYNC(TriggerOut),
	.oOUTPUT_CLK_RESET(CLK_custom_reset),

	.oARMED(Armed)
	,.oTEST(Test[3:0])
);

endmodule
