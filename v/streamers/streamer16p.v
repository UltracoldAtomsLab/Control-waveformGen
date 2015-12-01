module streamer16p
`include "v/streamers/streamer_body.h"
reg [4:0] Index;
reg [4:0] IndexMax, IndexMax_next;
reg [4:0] IndexR, IndexR_next;
reg [4:0] IndexW, IndexW_next;

onchip_16_pulse mem(
   .address(Index),
   .clock(iCLK),
   .data(iDATA_TIME),
   .wren(|WrEn),
   .q(TimeToChange)
);
endmodule
