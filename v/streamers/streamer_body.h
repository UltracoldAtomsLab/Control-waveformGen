/// in this file, I wrote the common part of different streamers,
/// including the IO declaration and behavior.
(
	iNRST,
	iCLK,
	iENABLE,
	iTIME_COUNTER,
	iCTRL_MODE,
    iDATA_CHANNEL,
	iDATA_TIME,
	iDATA_CH_VAL,
	iFLAG_T_EDGE_CATCH,
	iFLAG_V_EDGE_CATCH,
	oWAVEFORM
//	,oTest
);

`include "v/para.h"
parameter             ID     = 8'd1;
input                 iNRST;
input                 iCLK;
input                 iENABLE;
input [`bitNum-1:0]   iTIME_COUNTER;
input [7:0]           iCTRL_MODE;
input [1:0]           iFLAG_T_EDGE_CATCH;
input [1:0]           iFLAG_V_EDGE_CATCH;
input [7:0]           iDATA_CHANNEL;
input [`bitNum-1:0]   iDATA_TIME;
input                 iDATA_CH_VAL;
output                oWAVEFORM;
wire [`bitNum-1:0]    TimeToChange;
wire                  IsThis;
reg [1:0]             WrEn, WrEn_next;
reg                   InitQ, InitQ_next;
reg                   Q, Q_next;

assign                oWAVEFORM = Q;
assign                IsThis = (iDATA_CHANNEL==ID);

// test
//output [4:0] oTest;
//assign oTest[0] = (iTIME_COUNTER==TimeToChange);
//assign oTest[1] = ToInvert;
//assign oTest[4:2] = IndexR;

//  for reference  ===============================
//reg [X:0] Index;
//reg [X:0] IndexMax, IndexMax_next;
//reg [X:0] IndexR, IndexR_next;
//reg [X:0] IndexW, IndexW_next;
//
//onchip_YY_pulse mem(
//   .address(Index),
//   .clock(iCLK),
//   .data(iDATA_TIME),
//   .wren(|WrEn),
//   .q(TimeToChange)
//);
//  reference end  ===============================
reg [2:0] Idx_R_State, Idx_R_State_next;
reg       ToInvert, ToInvert_next;
parameter IDX_R_ST_IDLE      = 3'd0;
parameter IDX_R_ST_SET       = 3'd1;
parameter IDX_R_ST_TO_CHANGE = 3'd2;
parameter IDX_R_ST_BUF0      = 3'd3;
parameter IDX_R_ST_BUF1      = 3'd4;
parameter IDX_R_ST_BUF2      = 3'd5;


always @ (*) begin
	if(IsThis && iCTRL_MODE==M_SET_CH_WAVE) begin
		Index = IndexW;
		if(iFLAG_T_EDGE_CATCH==2'b01) begin // positive edge
			WrEn_next = 2'd1;
			IndexMax_next = IndexW;
		end
		else begin
			WrEn_next = WrEn + (WrEn!=0); 
			IndexMax_next = IndexMax;
		end
		
		if(iFLAG_T_EDGE_CATCH==2'b10)// negative edge
			IndexW_next = IndexW + 1'b1;
		else 
			IndexW_next = IndexW;
	end
	else begin
		Index = IndexR;
		WrEn_next = WrEn + (WrEn!=0);
		IndexW_next = 0;
		IndexMax_next = IndexMax;
	end
	
	if(IsThis && iCTRL_MODE==M_SET_CH_INIT && iFLAG_V_EDGE_CATCH==2'b01)
		InitQ_next = iDATA_CH_VAL;
	else
		InitQ_next = InitQ;
	
	if(iCTRL_MODE == M_CMD_TO_INIT || iCTRL_MODE == M_CMD_ARM)
		Q_next = InitQ;
	else if(IsThis && iCTRL_MODE==M_SET_CH_VAL && iFLAG_V_EDGE_CATCH==2'b01)
		Q_next = iDATA_CH_VAL;
	else if(ToInvert)
		Q_next = !Q;
	else
		Q_next = Q;
	
	case(Idx_R_State)
		IDX_R_ST_IDLE:      Idx_R_State_next = (iCTRL_MODE != M_IDLE)?        IDX_R_ST_SET:
											   (iTIME_COUNTER==TimeToChange)? IDX_R_ST_TO_CHANGE :
											                                  IDX_R_ST_IDLE;
		IDX_R_ST_SET:       Idx_R_State_next = (iCTRL_MODE != M_IDLE)?        IDX_R_ST_SET : 
																			  IDX_R_ST_IDLE;
		IDX_R_ST_TO_CHANGE: Idx_R_State_next = IDX_R_ST_BUF0;
		IDX_R_ST_BUF0:      Idx_R_State_next = IDX_R_ST_BUF1;
		IDX_R_ST_BUF1:      Idx_R_State_next = IDX_R_ST_IDLE;
		IDX_R_ST_BUF2:      Idx_R_State_next = IDX_R_ST_IDLE;
		default:            Idx_R_State_next = IDX_R_ST_IDLE;
	endcase
	
	case(Idx_R_State)
		IDX_R_ST_IDLE:      IndexR_next = IndexR;
		IDX_R_ST_SET:       IndexR_next = IndexMax;
		IDX_R_ST_TO_CHANGE: IndexR_next = (IndexR==0)? IndexMax:IndexR-1'b1;
		IDX_R_ST_BUF0:      IndexR_next = IndexR;
		IDX_R_ST_BUF1:      IndexR_next = IndexR;
		IDX_R_ST_BUF2:      IndexR_next = IndexR;
		default:            IndexR_next = IndexR;
	endcase
	
	ToInvert_next = (Idx_R_State==IDX_R_ST_TO_CHANGE);
end

always @ (negedge iNRST or posedge iCLK)begin
	if(!iNRST) begin
		IndexMax <= 0;
		IndexR   <= 0;
		IndexW   <= 0;
		WrEn     <= 2'd0;
		InitQ    <= 1'b0;
		Q        <= 1'b0;
		Idx_R_State <= IDX_R_ST_IDLE;
		ToInvert <= 1'b0;
	end
	else begin
		IndexMax <= IndexMax_next;
		IndexR   <= IndexR_next;
		IndexW   <= IndexW_next;
		WrEn     <= WrEn_next;
		InitQ    <= InitQ_next;
		Q        <= Q_next;
		Idx_R_State <= Idx_R_State_next;
		ToInvert <= ToInvert_next;
	end
end