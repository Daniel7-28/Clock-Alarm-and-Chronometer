`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2023 02:21:43 AM
// Design Name: 
// Module Name: Chronometer
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


module Chronometer(
input clk,                      //clock   
      reset,                    //reset the Chonometer
      globalReset,              //reset everything
      B5,                       //start/stop the chonometer    
input [1:0]  mainState,         //to verify that is in the correct state(01)    
output [3:0] s1,                //seconds units
             s2,                //seconds tens
             min1,              //minutes units
             min2,              //minutes tens
             h1,                //hour units
             h2                 //hour tens
);


//time display
// min2 min1 : s2 s1

reg [5:0] hour = 0, min = 0, sec = 0; // this because in min and sec the large number is 60 so 2^6 = 64
integer frequency_counter = 0;
localparam frequency_limit = 100_000_000; //this is the frequency of the basys 3 

// Reset the Chronometer
always @(posedge clk)
    begin  
        if(reset == 1'b1 && mainState == 2'b01 || globalReset == 1'b1)
           {hour,min,sec} <= 0;

// Do the Counting
        else if(B5 == 1'b1) //&& mainState == 2'b01 && reset == 1'b0
                if(frequency_counter == frequency_limit)
                    begin
                        frequency_counter <= 0;
                        if(sec == 6'd59)
                            begin
                                sec <= 0;
                                if(min == 6'd59)
                                    begin
                                        min <= 0;
                                        if(hour <= 6'd23)
                                            hour <= 0;
                                        else
                                            hour <= hour + 1'd1;
                                    end
                                else
                                    min <= min + 1'd1;
                            end
                        else
                            sec <= sec + 1'd1; 
                     end
         else
            frequency_counter <= frequency_counter + 1;     
    end   
    
///Instantiating   the BCD modules to convert the numbers and display them on the seven segment display
BCD secondss(.binary(sec), .tens(s2), .ones(s1));
BCD minutess(.binary(min), .tens(min2), .ones(min1));
BCD hours(.binary(hour), .tens(h2), .ones(h1));
endmodule
