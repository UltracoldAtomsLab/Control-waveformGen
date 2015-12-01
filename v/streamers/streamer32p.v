module streamer32p
`include "v/streamers/streamer_body.h"
reg [5:0] Index;
reg [5:0] IndexMax, IndexMax_next;
reg [5:0] IndexR, IndexR_next;
reg [5:0] IndexW, IndexW_next;

onchip_32_pulse mem(
   .address(Index),
   .clock(iCLK),
   .data(iDATA_TIME),
   .wren(|WrEn),
   .q(TimeToChange)
);
endmodule
