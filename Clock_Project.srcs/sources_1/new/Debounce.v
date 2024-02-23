`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 09:12:06 PM
// Design Name: 
// Module Name: Debounce
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


module Debounce(
    input clk_in,   //clock
    input pb,       //push button      
    output led      //output
    );
    
    wire clk_out;
    wire Q1, Q2, Q2_bar;
    
    // this module is to slow down the frequency so it can read more precise
    Slow_CLock_4Hz u1(clk_in, clk_out);
    
    //D Flip-Flops
    D_FF d1(clk_out, pb, Q1, Q1_bar);
    D_FF d2(clk_out, Q1, Q2, Q2_bar);
    
    assign led = Q1 & Q2_bar;                
    
    
    /*This module debounces the pushbutton PB.
 *It can be added to your project files and called as is:
 *DO NOT EDIT THIS MODULE
 */

// Synchronize the switch input to the clock
//reg PB_sync_0;
//always @(posedge clk_in) PB_sync_0 <= pb;
//reg PB_sync_1;
//always @(posedge clk_in) PB_sync_1 <= PB_sync_0;

//// Debounce the switch
//reg [15:0] PB_cnt;
//always @(posedge clk_in)
//if(led==PB_sync_1)
//    PB_cnt <= 0;
//else
//begin
//    PB_cnt <= PB_cnt + 1'b1; 
//    if(PB_cnt == 16'hffff) led <= led; 
//end
endmodule
