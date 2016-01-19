Quantus II project for FPGA
===
Hsiou-Yuan Liu, Chung-You Shih

Overview
---
- Loading the program to the FPGA
- [advanced] Modifying the number of pulses for each channel, as well as the number of channels

Loading the program to the FPGA
---
1. Double click waveformGen.qpf
2. If you do not modify the Quartus II project, it should be compiled. You then proceed to the next step. Otherwise compile the project through clicking "start compilation"  
![](img/start_compilation.png)
3. Open the "Convert Programming Files" window  
![](img/convert_programing_file.png)
4. Select the Programming file type to JTAG Indirect Configuration (.jic) file. Configuration device selected to EPCS4.  
![](img/jic.png)
5. Left click Flash Loader item; then left click "Add Device"  
![](img/flash_loader.png)
6. Select the check boxes as those in the figure  
![](img/select_device.png)
7. Left click SOF Data item, and then left click Add File  
8. Select the sof file  
9. Left click waveformGen.sof item; left click Properties.  
10. mark the Compression box (if there is any problem regarding auto-loading, ignore steps 6 & 7 and redo)  
11. It now should look like this (figure in next slide). Then click Generate button.  
12. open the Programmer window  
13. Clean up the content of right-hand side table  
14. Connect the blaster and the click “Hardware Setup.”  
15. Click USB-Blaster and then click Close  
16. Click “Add File” and choose the only jic file.   
17. mark the checkboxes as those in the figure; click Start.  
18. Finally, you have to turn off the FPGA and then turn it on again.The program written onto the EPROM through .jic will be loaded to the FPGA automatically every time you turn on the FPGA.

[advanced] Modifying the number of pulses for each channel, as well as the number of channels
---
1. Open "table.txt" in subforder "VerilogGen"
2. Specify the number of pulses for each channel. The number of channels is equal to how many numbers you specify in table.txt
3. If you enter the numbers as the figure, it turns out to be:
 - 0th channel with 16 impulses (32 transition edge),
 - 1st with 16
 - 2nd with 16
 - 3rd with 8
 - 4th with 16
 - 5th with 32.
