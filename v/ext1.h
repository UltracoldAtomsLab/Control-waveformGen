streamer16p streamer0(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[0])
);
defparam streamer0.ID  = 8'd0;

streamer16p streamer1(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[1])
);
defparam streamer1.ID  = 8'd1;

streamer16p streamer2(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[2])
);
defparam streamer2.ID  = 8'd2;

streamer16p streamer3(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[3])
);
defparam streamer3.ID  = 8'd3;

streamer16p streamer4(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[4])
);
defparam streamer4.ID  = 8'd4;

streamer16p streamer5(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[5])
);
defparam streamer5.ID  = 8'd5;

streamer16p streamer6(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[6])
);
defparam streamer6.ID  = 8'd6;

streamer16p streamer7(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[7])
);
defparam streamer7.ID  = 8'd7;

streamer16p streamer8(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[8])
);
defparam streamer8.ID  = 8'd8;

streamer16p streamer9(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[9])
);
defparam streamer9.ID  = 8'd9;

streamer16p streamer10(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[10])
);
defparam streamer10.ID  = 8'd10;

streamer16p streamer11(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[11])
);
defparam streamer11.ID  = 8'd11;

streamer16p streamer12(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[12])
);
defparam streamer12.ID  = 8'd12;

streamer16p streamer13(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[13])
);
defparam streamer13.ID  = 8'd13;

streamer16p streamer14(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[14])
);
defparam streamer14.ID  = 8'd14;

streamer16p streamer15(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[15])
);
defparam streamer15.ID  = 8'd15;

streamer16p streamer16(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[16])
);
defparam streamer16.ID  = 8'd16;

streamer16p streamer17(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[17])
);
defparam streamer17.ID  = 8'd17;

streamer16p streamer18(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[18])
);
defparam streamer18.ID  = 8'd18;

streamer16p streamer19(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[19])
);
defparam streamer19.ID  = 8'd19;

streamer16p streamer20(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[20])
);
defparam streamer20.ID  = 8'd20;

streamer16p streamer21(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[21])
);
defparam streamer21.ID  = 8'd21;

streamer16p streamer22(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[22])
);
defparam streamer22.ID  = 8'd22;

