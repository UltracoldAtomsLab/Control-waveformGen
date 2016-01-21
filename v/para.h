`define                     bitNum                32

// RS232 Decoder Mode, also the byte received from PC
parameter M_IDLE           = 8'h00; //
parameter M_SET_PERIOD     = 8'h01; //
parameter M_SET_CH_WAVE    = 8'h02;
parameter M_SET_CH_INIT    = 8'h03; //
parameter M_SET_CH_VAL     = 8'h04; //
parameter M_SET_SPL_RATE   = 8'h05;
parameter M_CMD_ARM        = 8'h80; //
parameter M_CMD_TO_INIT    = 8'h81; //
parameter M_CMD_RESET_TIME = 8'h82; //
parameter M_CMD_RESET_DEV  = 8'hFF; // reset the whole device
