`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 11:39:16
// Design Name: 
// Module Name: Dip_SW_input
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


module Dip_SW_input(
  
    input [3:0] hex_1,  // doesn't use in this project
    input [3:0] hex_2,  // doesn't use in this project
    input [3:0] sel,    //  select signal for turning on which 7-segment on FPGA
    input show_in,      // signal for display mode ;  index = 0 , display hour : min ;  index = 1 , display min : sec
    input alarm_d,      //  signal for display alarm clock time data ;  index = 0 , display clock time data ;  index = 1 , display alarm clock time data
    input [47:0] counter,  // 48'b combinding time data ( { alarm clock time data,  clock time data } )
                           // ( { al_hour_tens, al_hour_ones, al_min_tens, al_min_ones, al_sec_tens, al_sec_ones, hour_tens, hour_ones, min_tens, min_ones, sec_tens, sce_ones }  )
                           // each decimal number is 4 bits
    output reg [3:0] hex_out  // output signal for diplay which time data 
);  
   
    always@(counter or sel )
        if(show_in==0 && alarm_d==0)           //  show_in index = 0 , display hour : min ;  alarm_d index = 0 , display clock time data
            begin
                case(sel)
                    4'b1110:hex_out = counter[11:8];    // turn on 1st 7-segment, display  min_ones
                    4'b1101:hex_out = counter[15:12];   // turn on 2nd 7-segment, display  min_tens
                    4'b1011:hex_out = counter[19:16];   // trnn on 3rd 7-segment, display hour_ones
                    4'b0111:hex_out = counter[23:20];   // trnn on 4th 7-segment, display hour_tens	        		     
                endcase
            end
		
            else if (show_in==1 && alarm_d==0)    //  show_in index = 1 , display min : sec ;  alarm_d  index = 0 , display clock time data
                begin
                    case(sel)
                        4'b1110:hex_out = counter[3:0];   // turn on 1st 7-segment, display  sec_ones
                        4'b1101:hex_out = counter[7:4];   // turn on 2nd 7-segment, display  sec_tens
                        4'b1011:hex_out = counter[11:8];  // trnn on 3rd 7-segment, display min_ones
                        4'b0111:hex_out = counter[15:12]; // trnn on 4th 7-segment, display min_tens         		     
                    endcase
                end
      
            else if(show_in==0 && alarm_d==1)    //  show_in index = 0 , display hour : min ;  alarm_d  index = 1 , display alarm clock time data
                begin
                    case(sel)		 
                        4'b1110:hex_out = counter[35:32];  // turn on 1st 7-segment, display  al_min_ones
                        4'b1101:hex_out = counter[39:36];  // turn on 2nd 7-segment, display  al_min_tens
                        4'b1011:hex_out = counter[43:40];  // trnn on 3rd 7-segment, display al_hour_ones
                        4'b0111:hex_out = counter[47:44];  // trnn on 4th 7-segment, display al_hour_tens	 	        		      
                    endcase
                end
		
           else if (show_in==1 && alarm_d==1)    //  show_in index = 1 , display min : sec ;  alarm_d index = 1 , display alarm clock time data
                begin
                    case(sel)
                        4'b1110:hex_out = counter[27:24];  // turn on 1st 7-segment, display  al_sec_ones
                        4'b1101:hex_out = counter[31:28];  // turn on 2nd 7-segment, display  al_sec_tens
                        4'b1011:hex_out = counter[35:32];  // trnn on 3rd 7-segment, display al_min_ones
                        4'b0111:hex_out = counter[39:36];  // trnn on 4th 7-segment, display al_min_tens       		            
                    endcase
                end			 
endmodule

