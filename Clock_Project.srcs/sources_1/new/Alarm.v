`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 07:09:44 PM
// Design Name: 
// Module Name: Alarm
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


module Alarm(
    input clk,              //This is a clock signal to verify the signals in each period of time if they change or not
          reset,            //This is to reset the alarm
          globalReset,      //Reste everything 
          en,               //This is to enable/disable the Alarm
          enClk,            //Enable of the clock- this is used to enable the sound of the alarm when the clock is enable
          B1,               //This is to change to different states of the digital clock
          B2,               //This is to turn on the settings
          B3,               //This is to toggle to configure the hour/minute
          B4,               //This is to increment the hour/minute and to postponed the alarm
          clockPeriod,      //This is to verify if the time is morning or eveing period
    input [1:0] mainState,  //This is the represents the states
                secondaryState, //this is to know in which state is
    input [3:0] clockH1,     //hour units of the clock to verify that the hour units is equal to the alarm hour units
                clockH2,     //hour tens of the clock to verify that the hour tens is equal to the alarm hour tens
                clockM1,     //minutes units of the clock to verify that the minutes units is equal to the alarm minutes units
                clockM2,     //minutes tens of the clock to verify that the minutes tens is equal to the alarm minutes tens
    output reg Buzzer,       //This is the signal to send to the buzzer
    output reg alarmPeriod,  //This is the period of the alarm to verify is the alarm is in the morning or evening if is in 12 hour format
               RGBLEDs,      //This is the signal to send to the RGBLEDs
    output [3:0] s1,         //seconds units
                 s2,         //seconds tens
                 min1,       //minutes units
                 min2,       //minutes tens
                 h1,         //hour units
                 h2          //hour tens
    );
    
//time display
// h2 h1: min2 min1

reg [7:0] hour = 0, min = 0, sec = 0; // this because in min and sec the large number is 60 so 2^6 = 64
reg [7:0] limit = 8'd11;
reg buzz = 1'b0;
reg period = 1'b0;
reg rgb = 1'b0;
reg activateAlarm = 0;
reg [8:0] soundCounter = 9'b0_0000_0000;
reg [8:0] soundLimit = 9'b1_0010_1100;
integer frequency_counter = 0;
localparam frequency_limit = 100_000_000; //this is the frequency of the basys 3 

// Reset the clock
always @(posedge clk)
    begin  
        if(reset == 1'b1 && mainState == 2'b10 || globalReset == 1'b1)
            begin
                {hour,min,sec} <= 0;
                alarmPeriod <= 1'b0;
                soundCounter <= 0;
                activateAlarm <= 1'b0;
                frequency_counter <= 0;
                buzz <= 1'b0;
                rgb <= 1'b0;
            end

            
// Setting the time for the Alarm
        else 
        if(mainState == 2'b10 && B2 == 1'b1 && B3 == 1'b0 && B4 == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en ==1'b0) 
                if( min == 8'd59)
                    min <= 0;
                else 
                    min <= min + 1'd1;
        else if(mainState == 2'b10 && B2 == 1'b1 && B3 == 1'b1 && B4 == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en ==1'b0)
                if(hour == limit)
                    begin
                        if(limit == 8'd11)
                            period <= ~period;
                        hour <= 0;
                    end


                else 
                    hour <= hour + 1'd1;
                    
// 24 or 12 Format Hour           
        else 
        if(mainState == 2'b00 && secondaryState == 2'b01 && B2 == 1'b0 && B3 == 1'b0 && reset == 1'b0 && globalReset == 1'b0)
            begin
                if(hour > 8'd11)
                    begin
                        hour <= hour - 8'd12;
                        period <= 1'b1;
                    end
                limit <= 8'd11;
            end 
        else if(mainState == 2'b00 && secondaryState == 2'b01 && B2 == 1'b0 && B3 == 1'b1 && reset == 1'b0 && globalReset == 1'b0)
            begin 
                if(period == 1'b1)
                    begin
                        hour <= hour + 8'd12;
                        period <= 0;
                    end 
                limit <= 8'd23; 
            end
            
// Alarm activation     
        if(en == 1'b1 && enClk == 1'b1 && clockH2 == h2 && clockH1 == h1 && clockM2 == min2 && clockM1 == min1 && clockPeriod == period && reset == 1'b0 && globalReset == 1'b0)
            begin
                activateAlarm <= 1'b1;
            end
        if(activateAlarm == 1'b1)    
            if(frequency_counter == frequency_limit)
                begin
                    frequency_counter <= 0;
                    if(soundCounter == soundLimit)
                        begin
                            soundCounter <= 0;
                            activateAlarm <= 1'b0; 
                            buzz <= 1'b0;
                            rgb <= 1'b1;            //this is to know that the time for the alarm has passed and it need to be reseted
                        end
                    else if(en == 1'b0 || enClk == 1'b0)
                        begin
                            activateAlarm <= 1'b0; 
                            soundCounter <= 0;
                            buzz <= 1'b0;
                            rgb <= 1'b0;
                        end
                    else
                        begin
                            soundCounter <= soundCounter + 1'b1;
                            buzz <= ~buzz;
                            rgb <= ~rgb;
                        end
                end
            else
                frequency_counter <= frequency_counter + 1; 
                       
// Postponed the alarm
       if(mainState == 2'b10 && activateAlarm == 1'b1 && B2 == 1'b0 && B4 == 1'b1 && reset == 1'b0 && globalReset == 1'b0) 
           begin
                activateAlarm <= 1'b0;
                frequency_counter <= 0;
                soundCounter <= 0;
                buzz <= 1'b0;
                rgb <= 1'b0;
                if(min >= 8'd55)
                    begin 
                        min <= {clockM2, clockM1};
                        min <= min - 8'd55;
                        if(hour == limit)
                            begin 
                                hour <= 0;
                                if(limit == 8'd11)
                                    period <= ~period;
                            end
                        else
                            begin
                                hour <= {clockH2, clockH1};
                                hour <= hour + 1'd1;
                            end
                     end
                else
                    begin
                        min <= {clockM2, clockM1};
                        min <= min + 8'd5;
                    end
           end 
                                     
       Buzzer <= buzz;
       alarmPeriod <= period; 
       RGBLEDs <= rgb;      
    end   
    
///Instantiating   the BCD modules to convert the numbers and display them on the seven segment display
BCD secondss(.binary(sec), .tens(s2), .ones(s1));
BCD minutess(.binary(min), .tens(min2), .ones(min1));
BCD hours(.binary(hour), .tens(h2), .ones(h1));
endmodule
