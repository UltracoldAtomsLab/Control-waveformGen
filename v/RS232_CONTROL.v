module RS232_CONTROL(
	iNRST,             // the reset signal
	iCLK,              // the clock, 50M Hz
	iRXD,              // recieving channel from computer

	oMode,
	oMODE_SET_CH_WAVEFORM,
	oMODE_SET_CH_INIT_VAL,
	oMODE_SET_CH_VAL_FORCED,
	oMODE_SET_PERIOD,
	oMODE_CMD_ARM,
	oMODE_CMD_TO_INIT,
	oMODE_CMD_RESET_TIME,
	oMODE_CMD_RESET_DEV,

	oFLAG_TIME_READY,
	oFLAG_CH_VAL_READY,
	oFLAG_SPL_RATE_READY,
	oDATA_CHANNEL,
	oDATA_TIME,
	oDATA_CH_VAL,
	oSPL_RATE

);
/// The behavior of this module is to decode the data received from PC
/// Mode M_IDLE is waiting for a command byte to tell which Mode to proceed
///    To know the command byte, refer to para.h
`include "v/para.h"

`define s 4
// substate
// common substates
parameter SUB_Initial       = `s'd0;
parameter SUB_SubEnd        = `s'hFFFFFFFF;
// M_SET_CH_WAVE
parameter SUB_GetChannel    = SUB_Initial;
parameter SUB_GetNumOfTime0 = `s'd1;
parameter SUB_GetNumOfTime1 = `s'd2;
parameter SUB_GetTime0      = `s'd3;
parameter SUB_GetTime1      = `s'd4;
parameter SUB_GetTime2      = `s'd5;
parameter SUB_GetTime3      = `s'd6;
// M_SET_CH_INIT, M_SET_CH_VAL
//parameter SUB_GetChannel    = SUB_Initial;
parameter SUB_GetValue      = `s'd1;
// M_SET_PERIOD
parameter SUB_GetPeriod0    = SUB_Initial;
parameter SUB_GetPeriod1    = `s'd1;
parameter SUB_GetPeriod2    = `s'd2;
parameter SUB_GetPeriod3    = `s'd3;
// M_SET_SPL_RATE
parameter SUB_GetSplRate		= `s'd1;

// ==== I/O, Reg, Wire Declaration ======================================
input                     iNRST;
input                     iCLK;
input                     iRXD;

output [7:0]              oMode                   = Mode;
output                    oMODE_SET_CH_WAVEFORM   = (Mode==M_SET_CH_WAVE);
output                    oMODE_SET_CH_INIT_VAL   = (Mode==M_SET_CH_INIT);
output                    oMODE_SET_CH_VAL_FORCED = (Mode==M_SET_CH_VAL);
output                    oMODE_SET_PERIOD        = (Mode==M_SET_PERIOD);
output                    oMODE_CMD_ARM           = (Mode==M_CMD_ARM);
output                    oMODE_CMD_TO_INIT       = (Mode==M_CMD_TO_INIT);
output                    oMODE_CMD_RESET_TIME    = (Mode==M_CMD_RESET_TIME);
output                    oMODE_CMD_RESET_DEV     = (Mode==M_CMD_RESET_DEV);
output                    oFLAG_TIME_READY        = FlagTime_delay[15];
output                    oFLAG_CH_VAL_READY      = FlagVal_delay[15];
output										oFLAG_SPL_RATE_READY		= FlagSplRate;
output [7:0]              oDATA_CHANNEL           = Channel;
output [`bitNum-1:0]      oDATA_TIME              = (Mode==M_SET_PERIOD)? Period : Time;
output                    oDATA_CH_VAL            = Value;
output [7:0]							oSPL_RATE								= SplRate;
wire                      mDataReady;
wire [7:0]                mData;
reg                       CLOCK_25;
reg [7:0]                 Mode,        Mode_next;
reg [`s-1:0]              sub_state,   sub_state_next;
reg [7:0]                 Channel,     Channel_next;
reg [15:0]                NumOfTime,   NumOfTime_next;
reg [`bitNum-1:0]         Time,        Time_next;
reg [`bitNum-1:0]         Period,      Period_next;
reg                       Value,       Value_next;
reg                       FlagTime,    FlagTime_next;
reg                       FlagVal,     FlagVal_next;
reg [15:0]                FlagTime_delay, FlagVal_delay;
reg												FlagSplRate, FlagSplRate_next;
reg [7:0]									SplRate,     SplRate_next;

// ==== Structural Design ==============================
always @ (posedge iCLK)
	CLOCK_25 <= !CLOCK_25;

async_receiver AR(
	.clk(CLOCK_25),
	.RxD(iRXD),
	.RxD_data_ready(mDataReady),
	.RxD_data(mData),
	.RxD_endofpacket(),
	.RxD_idle()
);

always @ (*) begin
	// Mode_next
	if(Mode == M_IDLE)
		case(mData)
			M_SET_CH_WAVE:    Mode_next = mData;
			M_SET_PERIOD:     Mode_next = mData;
			M_SET_CH_INIT:    Mode_next = mData;
			M_SET_CH_VAL:     Mode_next = mData;
			M_SET_SPL_RATE:		Mode_next = mData;
			M_CMD_ARM:        Mode_next = mData;
			M_CMD_TO_INIT:    Mode_next = mData;
			M_CMD_RESET_TIME: Mode_next = mData;
			M_CMD_RESET_DEV:  Mode_next = mData;
			default:          Mode_next = M_IDLE;
		endcase
	else begin
		if(sub_state == SUB_SubEnd)
			Mode_next = M_IDLE;
		else
			Mode_next = Mode;
	end

	// sub_state_next
	case(Mode)
		M_IDLE:
			sub_state_next = SUB_Initial;
		M_SET_CH_WAVE:
			case(sub_state)
				SUB_GetChannel:    sub_state_next = (mData==255)?        SUB_SubEnd : sub_state+1'b1; // if get 255th preserved channel, go to SUB_SubEnd
				SUB_GetNumOfTime1: sub_state_next = (NumOfTime_next==0)? SUB_GetChannel : SUB_GetTime0; // this is for the empty channel case
				SUB_GetTime3  :    sub_state_next = (NumOfTime==0)?      SUB_GetChannel : SUB_GetTime0; // if get all the time data, back to SUB_GetChannel
				default       :    sub_state_next = sub_state + 1'b1;
			endcase
		M_SET_PERIOD:
			case(sub_state)
				SUB_GetPeriod3: sub_state_next = SUB_SubEnd;
				default       : sub_state_next = sub_state + 1'b1;
			endcase
		M_SET_CH_INIT: // set the initial value of a channel
			case(sub_state)
				SUB_GetChannel: sub_state_next = (mData==255)?   SUB_SubEnd : SUB_GetValue; //if get 255th preserved channel, go to SUB_SubEnd
				SUB_GetValue  : sub_state_next = SUB_GetChannel;
				default       : sub_state_next = SUB_SubEnd; // not allowed
			endcase
		M_SET_CH_VAL: // forcing a channel to some value.
			case(sub_state)
				SUB_GetChannel: sub_state_next = (mData==255)?   SUB_SubEnd : SUB_GetValue; //if get 255th preserved channel, go to SUB_SubEnd
				SUB_GetValue  : sub_state_next = SUB_GetChannel;
				default       : sub_state_next = SUB_SubEnd; // not allowed
			endcase
		M_SET_SPL_RATE:
			sub_state_next = SUB_SubEnd;
		M_CMD_ARM:
			sub_state_next = SUB_SubEnd;
		M_CMD_TO_INIT:
			sub_state_next = SUB_SubEnd;
		M_CMD_RESET_TIME:
			sub_state_next = SUB_SubEnd;
		M_CMD_RESET_DEV:
			sub_state_next = SUB_SubEnd;
		default:
			sub_state_next = SUB_Initial;// not allowed
	endcase
end


// Registers works with mData
always @ (*) begin
	// Channel, NumOfTime, Time, Value
	case(Mode)
		M_SET_CH_WAVE: begin
			Value_next = Value;
			case(sub_state)
				SUB_GetChannel:     Channel_next = mData;
				default:            Channel_next = Channel;
			endcase
			case(sub_state)
				SUB_GetNumOfTime0:  NumOfTime_next = {NumOfTime[7:0], mData};
				SUB_GetNumOfTime1:  NumOfTime_next = {NumOfTime[7:0], mData};
				SUB_GetTime0:       NumOfTime_next = NumOfTime - 1'b1;
				default:            NumOfTime_next = NumOfTime;
			endcase
			case(sub_state)
				SUB_GetNumOfTime1:  Time_next = 0;
				SUB_GetTime0:       Time_next = {Time[`bitNum-1-8:0], mData};
				SUB_GetTime1:       Time_next = {Time[`bitNum-1-8:0], mData};
				SUB_GetTime2:       Time_next = {Time[`bitNum-1-8:0], mData};
				SUB_GetTime3:       Time_next = {Time[`bitNum-1-8:0], mData};
				default:            Time_next = Time;
			endcase
		end
		M_SET_CH_INIT: begin
			NumOfTime_next = NumOfTime;
			Time_next = Time;
			case(sub_state)
				SUB_GetChannel:     begin Channel_next = mData;     Value_next = Value;    end
				SUB_GetValue:       begin Channel_next = Channel;   Value_next = mData[0]; end
				default:            begin Channel_next = Channel;   Value_next = Value;    end
			endcase
		end
		M_SET_CH_VAL: begin
			NumOfTime_next = NumOfTime;
			Time_next = Time;
			case(sub_state)
				SUB_GetChannel:     begin Channel_next = mData;     Value_next = Value;    end
				SUB_GetValue:       begin Channel_next = Channel;   Value_next = mData[0]; end
				default:            begin Channel_next = Channel;   Value_next = Value;    end
			endcase
		end

		M_SET_SPL_RATE: begin
			SplRate_next = mData;
		end

		default: begin
			NumOfTime_next = 0;
			Time_next = 0;
			Channel_next = 8'hFF;
			Value_next = 0;
		end
	endcase

	// Period
	if(Mode == M_SET_PERIOD)
		case(sub_state)
			SUB_GetPeriod0: Period_next = {Period[`bitNum-1-8:0], mData};
			SUB_GetPeriod1: Period_next = {Period[`bitNum-1-8:0], mData};
			SUB_GetPeriod2: Period_next = {Period[`bitNum-1-8:0], mData};
			SUB_GetPeriod3: Period_next = {Period[`bitNum-1-8:0], mData};
			default:        Period_next = Period;
		endcase
	else
		Period_next = 0;
end

always @ (*) begin
	// FlagTime, FlagVal
	case(Mode)
		M_SET_CH_WAVE: FlagTime_next = (sub_state==SUB_GetTime3)||(sub_state==SUB_GetNumOfTime1 && NumOfTime_next==0);// the later is added for the empty channel case
		M_SET_PERIOD:  FlagTime_next = (sub_state==SUB_GetPeriod3);
		default:       FlagTime_next = 1'b0;
	endcase
	case(Mode)
		M_SET_CH_INIT: FlagVal_next = (sub_state==SUB_GetValue);
		M_SET_CH_VAL:  FlagVal_next = (sub_state==SUB_GetValue);
		default:       FlagVal_next = 1'b0;
	endcase
	case(Mode)
		M_SET_SPL_RATE:FlagSplRate_next = (sub_state == SUB_Initial);
		default:       FlagSplRate_next = 1'b0;
	endcase
end



// to avoid potential hazard of Mode transistion,
// change the value of states later than other registers.
always @ (negedge iNRST or posedge iCLK) begin
	if(!iNRST) begin
		FlagTime_delay <= 16'd0;
		FlagVal_delay  <= 16'd0;
	end
	else begin
		FlagTime_delay <= {FlagTime_delay[14:0], FlagTime};
		FlagVal_delay  <= {FlagVal_delay[14:0],  FlagVal};
	end
end
always @ (negedge iNRST or negedge mDataReady) begin
	if(!iNRST) begin
		Mode     <= M_IDLE;
		sub_state <= SUB_Initial;
	end
	else begin
		Mode     <= Mode_next;
		sub_state <= sub_state_next;
	end
end
always @ (negedge iNRST or posedge mDataReady) begin
	if(!iNRST) begin
		Channel   <= 8'hFF;
		NumOfTime <= 16'd0;
		Time      <= `bitNum'd0;
		Period    <= `bitNum'd0;
		Value     <= 1'b0;
		FlagTime  <= 1'b0;
		FlagVal   <= 1'b0;
		FlagSplRate <= 1'b0;
		SplRate   <= 0;
	end
	else begin
		Channel   <= Channel_next;
		NumOfTime <= NumOfTime_next;
		Period    <= Period_next;
		Time      <= Time_next;
		Value     <= Value_next;
		FlagTime  <= FlagTime_next;
		FlagVal   <= FlagVal_next;
		FlagSplRate <= FlagSplRate_next;
		SplRate 	<= SplRate_next;
	end
end

endmodule
