template = '''streamer{ch_leng}p streamer{index}(
   .iCLK (iCLK),
   .iNRST(iNRST),
   .iTIME_COUNTER (TimeCounter),
   .iCTRL_MODE    (iCTRL_MODE),
   .iDATA_CHANNEL (iDATA_CHANNEL),
   .iDATA_TIME    (iDATA_TIME),
   .iDATA_CH_VAL  (iDATA_CH_VAL),
   .iFLAG_T_EDGE_CATCH(FlagTEdgeCatch),
   .iFLAG_V_EDGE_CATCH(FlagVEdgeCatch),
   .oWAVEFORM     (oWAVEFORM[{index}])
);
defparam streamer{index}.ID  = 8'd{index};

'''

def main():
    channel = []
    r = str(raw_input('''Do you want to load the file "table.txt?" (y/n) '''))
    if r == 'y':
        with open("table.txt") as fin:
            for line in fin:
                i = int(line)
                channel.append(i)
        n = len(channel)
        if n >= 255:
            print("make warning: Possible truncation of data.")
    else:
        while True:
            n = int(raw_input("Please enter the number of channels: "))
            if n <= 0 or n >= 255:
                print("make error: Please enter an integer in 1 to 255: ")
                continue
            else:
                break
        for k in range(n):
            i = int(raw_input("The amount of pulse for channel {0}".format(k+1)))
            channel.append(i)

    with open("../v/ext1.h", 'w') as fout:
        for index in range(n):
            to_write = template.format(ch_leng = channel[index], index = index)
            fout.write(to_write)

    with open("log.txt", 'w') as oflog:
        oflog.write("{0} channels\n".format(n))
        for index in range(n):
            to_write = "#{index}:\t{ch_leng}impulses\n".format(ch_leng = channel[index], index = index)
            oflog.write(to_write)

if __name__ == "__main__":
    main()
