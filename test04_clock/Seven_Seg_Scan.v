`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 14:41:12
// Design Name: 
// Module Name: Seven_Seg_Scan
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Seven_Seg_Scan(

    input base_scan_clock,     //  from clk_div [0] = (50MHz) / (2^17) = 381.47 Hz
    input RESETn,
    output reg [3:0] scan_out  //  control signal for truning on which 7-segment  ( 7-segment X 4  on FPGA )

);
    reg [1:0] sel;             // 4 bits counter : 00 ->  01 ->  10  -> 11  repeat
                               // sel is index for 4 cases 

    always@(posedge base_scan_clock or posedge RESETn)    // 4 bits counter : 00 ->  01 ->  10  -> 11  
        begin
            if(RESETn)
                sel<=2'b00;                               // reset to 00
            else
                sel<=sel+1'b1;                            // sel is index for 4 cases   
        end

    always@(sel[1:0])                                     // sel index changing triggers control signal for truning on which 7-segment 
        case(sel[1:0])
            2'b00:scan_out = 4'b1110;  // Enable U1 七段顯示器的第1顆 ( 由左邊往右邊數)
            2'b01:scan_out = 4'b1101;  // Enable U2 七段顯示器的第2顆
            2'b10:scan_out = 4'b1011;  // Enable U3 七段顯示器的第3顆
            2'b11:scan_out = 4'b0111;  // Enable U4 七段顯示器的第4顆 		 
        endcase

endmodule
