`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 15:02:35
// Design Name: 
// Module Name: Seven_segment_decoder
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

module Seven_segment_decoder(

    input [3:0] hex_in,                                // 4 bits control signal for FPGA 7段顯示器 (2^4 = 16 cases)
    output reg [7:0] segment_led_out                   //  FPGA 7段顯示器,共陽極電路, 低態制動, inpit = 0 -> trun on ;  inpit = 1 -> trun off
);   

    always @(hex_in)
        case(hex_in)
            4'b0001 : segment_led_out = 8'b11111001;   //1
            4'b0010 : segment_led_out = 8'b10100100;   //2
            4'b0011 : segment_led_out = 8'b10110000;   //3
            4'b0100 : segment_led_out = 8'b10011001;   //4
            4'b0101 : segment_led_out = 8'b10010010;   //5
            4'b0110 : segment_led_out = 8'b10000010;   //6
            4'b0111 : segment_led_out = 8'b11111000;   //7
            4'b1000 : segment_led_out = 8'b10000000;   //8
            4'b1001 : segment_led_out = 8'b10010000;   //9
            4'b1010 : segment_led_out = 8'b10001000;   //A
            4'b1011 : segment_led_out = 8'b10000011;   //b
            4'b1100 : segment_led_out = 8'b11000110;   //C
            4'b1101 : segment_led_out = 8'b10100001;   //d
            4'b1110 : segment_led_out = 8'b10000110;   //E
            4'b1111 : segment_led_out = 8'b10001110;   //F
            default : segment_led_out = 8'b11000000;   //0
        endcase
endmodule