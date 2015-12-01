module SEQ_WAVE_GEN(
	iNRST,
	iCLK,
	iCTRL_MODE,
	iFLAG_TIME_READY,
	iFLAG_CH_VAL_READY,
	iDATA_CHANNEL,
	iDATA_TIME,
	iDATA_CH_VAL,
	
	iTRIG,
	
	oWAVEFORM,
	oTRIG_SYNC,
	oOUTPUT_CLK_RESET,
	
	oARMED
	,oTEST
);
/// At this level we maintain all things about TimeCounter and Arm.
/// The initial value, forced value, set to initial will be maintained in
///    the exh1.h accompanied with streamer_body.h

`include "v/para.h"
input                 iNRST;
input                 iCLK;
input [7:0]           iCTRL_MODE;
input                 iFLAG_TIME_READY;
input                 iFLAG_CH_VAL_READY;
input [7:0]           iDATA_CHANNEL;
input [`bitNum-1:0]   iDATA_TIME;
input                 iDATA_CH_VAL;
input                 iTRIG;

output [254:0]        oWAVEFORM;
output                oTRIG_SYNC;
output                oOUTPUT_CLK_RESET;
output                oARMED;
output [7:0]          oTEST;
reg [3:0]             CounterState, CounterState_next;
reg [`bitNum-1:0]     TimeCounter, TimeCounter_next;
reg [`bitNum-1:0]     Period, Period_next;
reg [1:0]             TrigEdgeCatch, TrigEdgeCatch_next;
reg [7:0]             OutputSyncTrig, OutputSyncTrig_next;
//reg [1:0]             ExtClkEdgeCatch, ExtClkEdgeCatch_next;
reg [1:0]             FlagTEdgeCatch, FlagTEdgeCatch_next; // T: TimeReady
reg [1:0]             FlagVEdgeCatch, FlagVEdgeCatch_next; // V: ChannelValueReady
wire                  Armed;

`include "v/ext1.h"
parameter CNT_ST_IDLE                  = 4'd0;
parameter CNT_ST_ARMED                 = 4'd1; 
parameter CNT_ST_ARMED_CAUGHT_TRIG     = 4'd2;
parameter CNT_ST_RUN                   = 4'd4;
parameter CNT_ST_PERIODIC_RUN          = 4'd5;
parameter CNT_ST_PERIODIC_ZEROING      = 4'd7;
parameter TimeCounterMax = `bitNum'hFFFFFFFFFFFF;


assign oTRIG_SYNC        = (CounterState == CNT_ST_ARMED_CAUGHT_TRIG);
assign oOUTPUT_CLK_RESET = (CounterState == CNT_ST_ARMED_CAUGHT_TRIG);
assign oARMED = Armed;
assign Armed = (CounterState==CNT_ST_ARMED);
assign oTEST = CounterState;


always @ (*) begin
	case(CounterState)
		CNT_ST_IDLE: begin
			CounterState_next = (iCTRL_MODE==M_CMD_ARM)?         CNT_ST_ARMED : CounterState;
		end
		CNT_ST_ARMED: begin
			CounterState_next = (iCTRL_MODE!=M_IDLE && iCTRL_MODE!=M_CMD_ARM)? CNT_ST_IDLE :
                                (TrigEdgeCatch==2'b01)?                        CNT_ST_ARMED_CAUGHT_TRIG : CNT_ST_ARMED;
		end
		CNT_ST_ARMED_CAUGHT_TRIG: begin
			CounterState_next = (OutputSyncTrig != 8'd127)? CNT_ST_ARMED_CAUGHT_TRIG:
								(Period!=0)?                CNT_ST_PERIODIC_RUN : CNT_ST_RUN;
		end
		CNT_ST_RUN: begin
			CounterState_next = (iCTRL_MODE!=M_IDLE)?            CNT_ST_IDLE :
                                (TimeCounter==TimeCounterMax-1)? CNT_ST_IDLE : CNT_ST_RUN;
		end
		//CNT_ST_RUN_EXT_CAUGHT: begin
		//	CounterState_next = (TimeCounter==TimeCounterMax-1)? CNT_ST_IDLE : CNT_ST_RUN_WAIT_EXT;
		//end
		CNT_ST_PERIODIC_RUN: begin
			CounterState_next = (iCTRL_MODE!=M_IDLE) ?           CNT_ST_IDLE :
				                (TimeCounter==Period)?           CNT_ST_PERIODIC_ZEROING : CNT_ST_PERIODIC_RUN;
		end
		//CNT_ST_PERIODIC_EXT_CAUGHT: begin
		//	//CounterState_next = (TimeCounter==Period)?           CNT_ST_PERIODIC_ZEROING : CNT_ST_PERIODIC_WAIT_EXT;
		//	CounterState_next = (TimeCounter==TimeCounterMax-1)? CNT_ST_IDLE : CNT_ST_PERIODIC_WAIT_EXT;
		//end
		CNT_ST_PERIODIC_ZEROING: begin
			CounterState_next = CNT_ST_PERIODIC_RUN;
		end
		default:
			CounterState_next = CNT_ST_IDLE;
	endcase
	
	//
	case(CounterState)
		CNT_ST_ARMED:		            OutputSyncTrig_next = 8'd0;
		CNT_ST_ARMED_CAUGHT_TRIG:       OutputSyncTrig_next = OutputSyncTrig + 1'b1;
		default:                        OutputSyncTrig_next = 8'd0;
	endcase
	
	// the counter
	case(CounterState)
		CNT_ST_IDLE:                    TimeCounter_next = TimeCounterMax;
		CNT_ST_ARMED:                   TimeCounter_next = TimeCounterMax;
		CNT_ST_ARMED_CAUGHT_TRIG:       TimeCounter_next = 1;
		CNT_ST_RUN:                     TimeCounter_next = TimeCounter + 1'b1;
		//CNT_ST_RUN_EXT_CAUGHT:          TimeCounter_next = TimeCounter + 1'b1;
		CNT_ST_PERIODIC_RUN:            TimeCounter_next = TimeCounter + 1'b1;
		//CNT_ST_PERIODIC_EXT_CAUGHT:     TimeCounter_next = TimeCounter + 1'b1;
		CNT_ST_PERIODIC_ZEROING:        TimeCounter_next = 1;
		default:                        TimeCounter_next = TimeCounterMax;
	endcase

	TrigEdgeCatch_next   = {TrigEdgeCatch[0],   iTRIG};
	//ExtClkEdgeCatch_next = {ExtClkEdgeCatch[0], iCLK_EXT};
	FlagTEdgeCatch_next  = {FlagTEdgeCatch[0],  iFLAG_TIME_READY};
	FlagVEdgeCatch_next  = {FlagVEdgeCatch[0],  iFLAG_CH_VAL_READY};

	//Period
	if(iCTRL_MODE==M_SET_PERIOD && FlagTEdgeCatch==2'b01)
		Period_next = iDATA_TIME;
	else
		Period_next = Period;
end

always @ (negedge iNRST or posedge iCLK) begin
	if(!iNRST) begin
		CounterState   <= CNT_ST_IDLE;
		TimeCounter    <= TimeCounterMax;
		Period         <= `bitNum'd0;
		TrigEdgeCatch  <= 2'b00;
		FlagTEdgeCatch <= 2'b00;
		FlagVEdgeCatch <= 2'b00;
		OutputSyncTrig <= 8'd0;
		//ExtClkEdgeCatch <= 2'b00;
	end
	else begin
		CounterState   <= CounterState_next;
		TimeCounter    <= TimeCounter_next;
		Period         <= Period_next;
		TrigEdgeCatch  <= TrigEdgeCatch_next;
		FlagTEdgeCatch <= FlagTEdgeCatch_next;
		FlagVEdgeCatch <= FlagVEdgeCatch_next;
		OutputSyncTrig <= OutputSyncTrig_next;
		//ExtClkEdgeCatch <= ExtClkEdgeCatch_next;
	end
end

endmodule
