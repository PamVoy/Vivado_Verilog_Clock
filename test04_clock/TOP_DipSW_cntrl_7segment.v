`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 10:32:06
// Design Name: 
// Module Name: TOP_DipSW_cntrl_7segment
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


module TOP_DipSW_cntrl_7segment(
				
    //input load_time;
    //input alarm;
    input clk,                 // FPGA clock : 50MHz
    input RESETn,              // FPGA switch : reset function
    input enable,              // FPGA switch : module enable/pause  function ;  input = 0  , module enable ;   input = 1  , module pause
    input modecb,              // FPGA buttom : clock mode change function  ;  buttom pressed >> 1.clock mode >> 2.  time calibration mode >> 3. alarm clock mode 
    input setting11,           // FPGA buttom : load sec data
    input setting22,           // FPGA buttom : load min data
    input setting33,   	       // FPGA buttom : load hour data
    input show_mode,	       // FPGA switch : 7-segmnet display switch function  ;  input = 0  , display hour : min ;   input = 1  , display min : sec
    input [3:0] DipSW_hex_1,   // doesn't use in this project
    input [3:0] DipSW_hex_2,   // doesn't use in this project
    
    output [7:0] Seven_segment_out,   // 7-segmnet decoder output
    output [3:0] Seven_segment_sel,   //  select which 7-segmnet is enable
    output reg sec_led,               // FPGA LED on the switch , for filcker funtion when second counting 
    output alarm_led,                 // FPGA LED on the switch , for displaying alarm clock funtion  
    output [5:0] testbug1,            // only for debug test
    output [5:0] testbug2,            // only for debug test
    output [5:0] testbug3             // only for debug test
 );

    
    wire [15:0] clk_div;              // 16 bits clock_divder output
    wire [3:0] Dip_hex_value;         // which time data to display
    wire al_to_led;                   // alarm output to FPGA LED on the switch      
    //wire [15:0] 	counter_wire;
    //wire 	counter10Co;
    wire deb1;                        // debounce to clock_sec
    wire deb_a1;                      // debounce to alarm_clock_sec
    wire deb2;                        // debounce to clock_min
    wire deb_a2;                      // debounce to alarm_clock_min
    wire deb3;                        // debounce to clock_hour
    wire deb_a3;                      // debounce to alarm_clock_hour
    
    wire [5:0] sec;                   //  clock_sec
    wire [5:0] al_sec;                // alarm_clock_sec
    wire [5:0] min;                   //  clock_min
    wire [5:0] al_min;                // alarm_clock_min
    wire [5:0] hour;                  //  clock_hour         
    wire [5:0] al_hour;               // alarm_clock_hour
	
	wire [3:0] secone;                // BCD for clock_second units digit    
	wire [3:0] a_secone;              // BCD for alarm_clock_secound units digit    
	wire [3:0] secten;                // BCD for clock_second tens digit            
	wire [3:0] a_secten;              // BCD for alarm_clock_secound tens digit     
	wire [3:0] minone;                // BCD for clock_minute units digit    
	wire [3:0] a_minone;              // BCD for alarm_clock_minute units digit     
	wire [3:0] minten;                // BCD for clock_minute tens digit  
	wire [3:0] a_minten;              // BCD for alarm_clock_minute tens digit                   
	wire [3:0] hourone;               // BCD for clock_hour units digit                        
	wire [3:0] a_hourone;             // BCD for alarm_clock_hour units digit
	wire [3:0] hourten;               // BCD for clock_hour  tens digit       
	wire [3:0] a_hourten;             // BCD for alarm_clock_hour  tens digit       
	wire [1:0] sechd;                 // BCD for clock_second hundreds digit      
	wire [1:0] minhd;                 // BCD for clock_minute hundreds digit
	wire [1:0] hourhd;                // BCD for clock_hour hundreds digit
	wire [1:0] a_sechd;               // BCD for alarm_clock_second hundreds digit  
	wire [1:0] a_minhd;               // BCD for alarm_clock_minute hundreds digit
	wire [1:0] a_hourhd;              // BCD for alarm_clock_hour hundreds digit
	
	wire fsm_load;                     // FSM to clock load time data
	wire fsm_alarm;                    // FSM to alarm clock load time data
	wire fsm_b;                        // FSM and FPGA buttom
	
	
	always @ (posedge clk)
        if(enable)                      // FPGA LED on the switch , for filcker funtion when second counting 
            begin 
                sec_led = clk_div[7];   // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
            end
        else
            begin
                sec_led = 1'b1;         //  turn on FPGA LED on the switch  ( 1 LED )
            end		
	
    assign testbug1 = al_sec;           // only for debug test
    assign testbug2 = al_min;           // only for debug test
    assign testbug3 = al_hour;          // only for debug test


//  Clock_divider :  clk_div_out [0] = (50MHz) / (2^17) = 381.47 Hz
Clk_Div U1(
    .clk(clk),                      // input : FPGA clock : 50MHz
    .RESETn(RESETn),                //  input : FPGA switch : reset function
    .clk_div_out(clk_div)           //  output : 16 bits clock_divder output ,  clk_div_out [0] = (50MHz) / (2^17) = 381.47 Hz
);
   
   
// Alarm clock time & clock time check module. When the time is the same, alarm signal -> trigger FPGA LED 
alarm_check ac1( 
    .reset(RESETn),                         // input : FPGA switch : reset function
    .clk_ac(clk_div[7]),                    // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz          
    .clock_inp({hour, min, sec}),           // input : 18 bits clock time data : hour, min, sec ; each one is 6 bits
    .alarm_inp({al_hour, al_min, al_sec}),  // input : 18 bits alarm clock time data : hour, min, sec ; each one is 6 bits
    .ot_ac(al_to_led)                       // output : alarm signal -> trigger FPGA LED 
);	
                      
    assign alarm_led = al_to_led;				  
  
  
   //This is a MUX module, user can pickup the input from DIP switch 
   // or counter.
Dip_SW_input U2(

    .hex_1(DipSW_hex_1),             // input : doesn't use in this project
    .hex_2(DipSW_hex_2),             // input : doesn't use in this project  
    .sel(Seven_segment_sel),         //  input : select signal for turning on which 7-segment on FPGA
    .alarm_d(fsm_alarm),             //  input :  signal for display alarm clock time data ;  index = 0 , display clock time data ;  index = 1 , display alarm clock time data ( FSM to alarm clock load time data )
    .show_in(show_mode),             //  input : signal for display mode ;  index = 0 , display hour : min ;  index = 1 , display min : sec ( FPGA switch : 7-segmnet display switch function )
    .counter({a_hourten,a_hourone,a_minten,a_minone,a_secten,a_secone  ,hourten,hourone,minten,minone,secten,secone}),  //  input : 48bits { BCD output }  , each time data is 4bits
    .hex_out(Dip_hex_value)          // output : which time data to display
);
   
   
   //Turn on the 7-Led digit sequentially. Scan display function.
Seven_Seg_Scan U3(

    .base_scan_clock(clk_div[0]),      // input :  clk_div_out [0] = (50MHz) / (2^17) = 381.47 Hz
    .RESETn(RESETn),                   // FPGA switch : reset function
    .scan_out(Seven_segment_sel)	   // output :  control signal for truning on which 7-segment  ( 7-segment X 4  on FPGA )  
 );


   //A 7 segment led decoder
Seven_segment_decoder U4(
    
    .hex_in(Dip_hex_value),             // input : 4 bits control signal for FPGA 7段顯示器 (2^4 = 16 cases) ( from Dip_SW_input U2 , which time data should be displayed)
    .segment_led_out(Seven_segment_out) // output : decode results : 0~9
);
				
				 
	// Clock counter ;  ( hour : min : sec ) ( 23:59:59 ) 
top_one clock ( 

    .clock(clk_div[7]),     // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    .reset_n(RESETn),       // input : FPGA switch : reset function
    .enable(enable),        // input : FPGA switch : module enable/pause  function 
    .load(fsm_load),        // input :  load time data ( frome FSM m_alarm control signal )
    .setting1(deb1),        // input :  load second time data ( debounce d_sec output )
    .setting2(deb2),        // input :  load minute time data ( debounce d_min output )
    .setting3(deb3),        // input :  load hour time data ( debounce d_hour output )
    .data_sec(1'b0),        // input : sec data  initialization
    .data_min(1'b0),        // input : min data initialization
    .data_hour(1'b0),       // input : hour data  initialization
    .count_sec(sec),        // output :  second
    .count_min(min),        // output :  minute
    .count_hour(hour),      // output :  hour
    .carry_hour(carry_hour) //  output : hour carry out
 );
   
   
	// Alarm clock module  ( hour : min : sec ) ( 23:59:59 ) 
 alarm_sec a1 ( 
 
     .clock(clk_div[7]),         // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
     .reset_sec(RESETn),         // input : FPGA switch : reset function
     .enable_sec(fsm_alarm),     // input :  load time data ( frome FSM m_alarm control signal )
     .setting_sec(deb_a1),       // input :  load time data ( frome debounce_alarm da_sec output )
     .count_sec(al_sec)          // output :  second 
 );
 
 alarm_min a2 ( 
 
     .clock(clk_div[7]),        // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
     .reset_min(RESETn),        // input : FPGA switch : reset function
     .enable_min(fsm_alarm),    // input :  load time data ( frome FSM m_alarm control signal )
     .setting_min(deb_a2),      // input :  load time data ( frome debounce_alarm da_min output )
     .count_min(al_min)         // output :  minute
 );
 
 alarm_hour a3 ( 
 
    .clock(clk_div[7]) ,         // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    .reset_hour(RESETn),         // input : FPGA switch : reset function
    .enable_hour(fsm_alarm),     // input :  load time data ( frome FSM m_alarm control signal )
    .setting_hour(deb_a3),       // input :  load time data ( frome debounce_alarm da_hour output )
    .count_hour(al_hour)         // output :  hour
 );
 

				 
 //BCD for clock second	
BCD in_sec(

    .A({2'b0,sec}),     // input :  8 bits =  { 2'b0 + 6'b sec }  ( from top_one clock  .count_sec output )
    .ONES(secone),      // output :  4 bits secound units digit 
    .TENS(secten),      // output :  4 bits secound tens digit 
    .HUNDREDS(sechd)    // output :  2 bits secound hundreds digit
);
	 
//BCD for clock minute
BCD in_min(

    .A({2'b0,min}),      // input :  8 bits =  { 2'b0 + 6'b min }  ( from top_one clock  .count_min output )
    .ONES(minone),       // output :  4 bits minute units digit 
    .TENS(minten),       // output :  4 bits minute tens digit 
    .HUNDREDS(minhd)     // output :  2 bits minute hundreds digit
);  
     
 //BCD for clock hour
BCD in_hour(     

    .A({2'b0,hour}),      // input :  8 bits =  { 2'b0 + 6'b hour }  ( from top_one clock  .count_hour output )
    .ONES(hourone),       // output :  4 bits hour units digit 
    .TENS(hourten),       // output :  4 bits hour tens digit 
    .HUNDREDS(hourhd)     // output :  2 bits hour hundreds digit
);


  //BCD for alarm clock second
BCD ba_sec (

    .A({2'b0,al_sec}),    // input :  8 bits =  { 2'b0 + 6'b sec }  ( from alarm_sec a1  .count_sec output )
    .ONES(a_secone),      // output :  4 bits secound units digit 
    .TENS(a_secten),      // output :  4 bits secound tens digit 
    .HUNDREDS(a_sechd)    // output :  2 bits secound hundreds digit
);


 //BCD for alarm clock minute
BCD ba_min (

    .A({2'b0,al_min}),    // input :  8 bits =  { 2'b0 + 6'b min }  ( from alarm_min a2  .count_min output )
    .ONES(a_minone),      // output :  4 bits minute units digit 
    .TENS(a_minten),      // output :  4 bits minute tens digit 
    .HUNDREDS(a_minhd)    // output :  2 bits minute hundreds digit
);


 //BCD for alarm clock hour
BCD ba_hour (

    .A({2'b0,al_hour}),   // input :  8 bits =  { 2'b0 + 6'b hour }  ( from alarm_hour a3  .count_hour output )
    .ONES(a_hourone),     // output :  4 bits hour units digit 
    .TENS(a_hourten),     // output :  4 bits hour tens digit 
    .HUNDREDS(a_hourhd)   // output :  2 bits hour hundreds digit
);

	 
	 //Debounce for FPGA buttom in clock_sec
 debounce d_sec(

     .cclk(clk),                // FPGA clock : 50MHz
     .clr(RESETn),              // FPGA switch : reset function
     .alarm_d(fsm_alarm),       // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting11),           // input :  FPGA buttom : load sec data
     .outp(deb1)                // output :  for top_one clock  .setting1(deb1)  ;  sec +1
 );  
 
 
    //Debounce for FPGA buttom in clock_min
 debounce d_min(
 
     .cclk(clk),                 // FPGA clock : 50MHz
     .clr(RESETn),               // FPGA switch : reset function
     .alarm_d(fsm_alarm),        // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting22),            // input :  FPGA buttom : load min data
     .outp(deb2)                 // output :  for top_one clock  .setting2(deb2)  ;  min +1
 );
 
     //Debounce for FPGA buttom in clock_hour
 debounce d_hour(
     
     .cclk(clk),                 // FPGA clock : 50MHz
     .clr(RESETn),               // FPGA switch : reset function
     .alarm_d(fsm_alarm),        // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting33),            // input :  FPGA buttom : load hour data
     .outp(deb3)                 // output :  for top_one clock  .setting3(deb3)  ;  hour +1
 );
 
 	 //Debounce for FPGA buttom in alarm clock_sec
 debounce_alarm da_sec(
 
     .cclk(clk),                // FPGA clock : 50MHz
     .clr(RESETn),              // FPGA switch : reset function
     .alarm_d(fsm_alarm),       // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting11),           // input :  FPGA buttom : load sec data
     .outp(deb_a1)              // output :  for  alarm_sec a1 .setting_sec(deb_a1) ; sec +1
 );
 
 
  	 //Debounce for FPGA buttom in alarm clock_min
 debounce_alarm da_min(
 
     .cclk(clk),                // FPGA clock : 50MHz
     .clr(RESETn),              // FPGA switch : reset function
     .alarm_d(fsm_alarm),       // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting22),           // input :  FPGA buttom : load min data
     .outp(deb_a2)              // output :  for  alarm_min a2 .setting_min(deb_a2) ; min +1
 );
 
 
 	 //Debounce for FPGA buttom in alarm clock_hour
 debounce_alarm da_hour(
 
     .cclk(clk),                  // FPGA clock : 50MHz
     .clr(RESETn),                // FPGA switch : reset function
     .alarm_d(fsm_alarm),         // input :  load time data ( frome FSM m_alarm control signal )
     .inp(setting33),             // input :  FPGA buttom : load hour data
     .outp(deb_a3)                // output :  for  alarm_hour a3 .setting_hour(deb_a3) ; hour +1
 );
 
	 
 //FSM_controller for clock  mode switch : 1.clock mode >> 2.  time calibration mode >> 3. alarm clock mode 
 FSM_01 modecontrol (
 
    .m_clk(clk_div[7]),            // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    .m_reset(RESETn),              // FPGA switch : reset function
    .trigger(fsm_b),               // input : FPGA buttum pressed ;  from  debounce_fsm fb01 .outp(fsm_b)
    .m_load(fsm_load),             // output : control signal for activating time calibration mode  (wire fsm_load)
    .m_alarm(fsm_alarm)            // output : control signal for activating  alarm clock mode (wire fsm_alarm )
 );
 
 //FSM_debounce  
 debounce_fsm fb01( 
 
    .cclk(clk_div[4]),            // input : clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^21) = 23.84 Hz
    .clr(RESETn),                 // FPGA switch : reset function
    .inp(modecb),                 // input : input modecb ; FPGA buttom 
    .outp(fsm_b)                  // output : debouncing signal for  FSM_01 modecontrol .trigger(fsm_b)
 );
    
          
endmodule
