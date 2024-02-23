`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 09:53:38 PM
// Design Name: 
// Module Name: System
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


module System(
    input clk,      // FPGA clk
    B1,             //change to alarm or Chronometer or Clock and if Settings are on it will change to set Hour, Toggle Format Hour and Toggle Daylight Saving Time.
    B2,             //On/Off Settings
    B3,             //Toggle Hour and minutes Settings. Also, if is in Toggle Format Hour it will toggle 24/12 hours Format and if is inDaylight it will turn off and on the daylight saving
    B4,             //Increment if is in set hour or set minute. If is in alarm state(10) and Button 2 is on(1) it will postponed the alarm.
    B5,             //Start/Stop Chronometer
    SW1,            //enable/disable the clock
    SW2,            //enable/disable the alarm
    SW3,            //reset the Alarm, Clock or Chonometer. It will reset the values of the state depending in which state it will be.
    SW4,            //reset everything
    output p,       //period of the clock if is in a.m.(value 0) or p.m(value 1). 
           btwo,    //this is to know when button 2 is 0 and when is 1 
           bthree,  //know when is 0 and when is 1
           Buzzer,  //This is to activate or deactivate the buzzer
           alarmPeriod, //period of the alarm if is in am or pm
           RGBLEDs,     //to activate or deactivate the RGB LEDs
    output [1:0] sstate,  //secondary state value
                 mstate,  //main state value
    output [6:0] seg,     //here are the values to turn on the display segments
    output [3:0] an,      //turn on each anode
    output [7:0] led      //display seconds
    );
    
    wire [3:0] s1, s2, m1, m2, h1, h2, s1_c, s2_c, m1_c, m2_c, h1_c, h2_c, s1_ch, s2_ch, m1_ch, m2_ch, h1_ch, h2_ch, s1_a, s2_a, m1_a, m2_a, h1_a, h2_a;
    wire [1:0] mainState, secondaryState;
//    wire alarmPeriod; //RGBLEDs;
    wire B2_bar, B3_bar, B5_bar;
    wire B1clr, B2clr, B3clr, B4clr, B5clr;
    reg B1_out, B2_out,B3_out, B4_out, B5_out; 
    reg B1clr_prev = 0,
        B2clr_prev = 0, 
        B3clr_prev = 0, 
        B4clr_prev = 0, 
        B5clr_prev = 0;
    
    // Instantiating the Debounce modules
    Debounce buttonCenter(clk, B1, B1clr); //Button 1
    Debounce buttonUp(clk, B2, B2clr); //Button 2
    Debounce buttonRight(clk, B3, B3clr); //Button 3
    Debounce buttonDown(clk, B4, B4clr); // button 4
    Debounce buttonLeft(clk, B5, B5clr); //button 5 
    
    //All of this is part of the Debouncer
    always@(posedge clk)//posedge B1clr, B2clr,B3clr,B4clr,B5clr
        begin
        
            B1clr_prev <= B1clr;
            B2clr_prev <= B2clr;
            B3clr_prev <= B3clr;
            B4clr_prev <= B4clr;
            B5clr_prev <= B5clr;
            
            if(B1clr_prev == 1'b0 && B1clr ==1'b1)  
                B1_out <= 1'b1; 
            else 
                B1_out <= 1'b0;
    
            if(B2clr_prev == 1'b0 && B2clr ==1'b1) 
                B2_out <= 1'b1; 
            else 
                B2_out <= 1'b0;
                  
            if(B3clr_prev == 1'b0 && B3clr ==1'b1) 
                B3_out <= 1'b1; 
            else 
                B3_out <= 1'b0;
           
            if(B4clr_prev == 1'b0 && B4clr ==1'b1)  
                B4_out <= 1'b1; 
            else 
                B4_out <= 1'b0;
                
           if(B5clr_prev == 1'b0 && B5clr ==1'b1)  
                B5_out <= 1'b1; 
            else 
                B5_out <= 1'b0;                 
        end
    
    //This modules are to toggle button 2, 3 and 5;
    ToggleButtons Button2(B2_out, B2_bar);
    ToggleButtons Button3(B3_out, B3_bar);
    ToggleButtons Button5(B5_out, B5_bar);
    
    //This module is for change from state to state and secondary states too
    BCDButton Button1(clk, SW4, SW3, B1_out, B2_bar, mainState, secondaryState);
    
    //Digital Clock Module
//  Digital_Clock(input clk, en, reset, globalReset, B2, B3, B4, input [1:0] mainState, secondaryState, output p, output [3:0] sec_1,sec_10,min_1,min_10,h_1,h_10)
    Digital_Clock CLK(clk, SW1, SW3, SW4, B2_bar, B3_bar, B4_out, mainState, secondaryState, p, s1_c, s2_c, m1_c, m2_c, h1_c, h2_c);
    
    //Chronometer Module
//  Chronometer(input clk, reset, globalReset, B5,input [1:0]  mainState,output [3:0] s1,s2,min1,min2,h1,h2);
    Chronometer Chron(clk, SW3, SW4, B5_bar, mainState, s1_ch, s2_ch, m1_ch, m2_ch, h1_ch, h2_ch);
    
    //Alarm Module
//  Alarm( input clk, reset, globalReset, en, B1, B2, B3, B4, clockPeriod, input [1:0] mainState, secondaryState, input [5:0] clockH, clockM, output reg Buzzer, output reg alarmPeriod, RGBLEDs, output [3:0] s1, s2, min1, min2, h1, h2);
    Alarm Alarm( clk, SW3, SW4, SW2, SW1, B1_out, B2_bar, B3_bar, B4_out, p, mainState, secondaryState, h1_c, h2_c, m1_c, m2_c, Buzzer, alarmPeriod, RGBLEDs, s1_a, s2_a, m1_a, m2_a, h1_a, h2_a);
    
    //This Multiplexer Module is for choose which state is going to be displayed on the Seven Segment Display
//  MuxCAC(input [1:0] option,input [3:0] s1_c, s2_c, m1_c, m2_c, h1_c, h2_c, s1_ch, s2_ch, m1_ch, m2_ch, h1_ch, h2_ch,s1_a, s2_a, m1_a, m2_a, h1_a, h2_a,output reg [3:0] s1, s2, m1, m2, h1, h2);
    MuxCAC MultiplexerOptions(mainState, s1_c, s2_c, m1_c, m2_c, h1_c, h2_c, s1_ch, s2_ch,m1_ch, m2_ch, h1_ch, h2_ch, s1_a, s2_a, m1_a, m2_a, h1_a, h2_a, s1, s2, m1, m2, h1, h2);
    
    
    //Instantiating seven segment driver
//  SevenSegmentController(input clk,clr,input [3:0] in_1,in_2,in_3,in_4,output reg [6:0] seg,output reg[3:0] an);
    SevenSegmentController SSC(clk, SW4, h2, h1, m2, m1, seg, an); //HH:MM
    
    //Assigning the seconds if is in Clock state or hours if in the Chronometer state to the LEDs
    assign led [7:0] = {s2,s1};
    
    //This assigns are to see if they are working properly and in which state or secondary state is
    assign sstate [1:0] = secondaryState;
    assign mstate [1:0] = mainState;
    assign btwo = B2_bar;
    assign bthree = B3_bar;
endmodule
