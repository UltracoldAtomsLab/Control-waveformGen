module streamer256p
`include "v/streamers/streamer_body.h"
reg [8:0] Index;
reg [8:0] IndexMax, IndexMax_next;
reg [8:0] IndexR, IndexR_next;
reg [8:0] IndexW, IndexW_next;

onchip_256_pulse mem(
   .address(Index),
   .clock(iCLK),
   .data(iDATA_TIME),
   .wren(|WrEn),
   .q(TimeToChange)
);
endmodule
