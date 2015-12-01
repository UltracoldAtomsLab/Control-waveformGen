module streamer64p
`include "v/streamers/streamer_body.h"
reg [6:0] Index;
reg [6:0] IndexMax, IndexMax_next;
reg [6:0] IndexR, IndexR_next;
reg [6:0] IndexW, IndexW_next;

onchip_64_pulse mem(
   .address(Index),
   .clock(iCLK),
   .data(iDATA_TIME),
   .wren(|WrEn),
   .q(TimeToChange)
);
endmodule
