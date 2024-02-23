`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 09:29:42 PM
// Design Name: 
// Module Name: Slow_CLock_4Hz
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


module Slow_CLock_4Hz(
    input clk_in,       //clock input
    output reg clk_out  //clock modified to be more slow
    );
    
    reg [25:0] count = 0; // 2^25 > 12.5 million

    //This will slow down the frequency of the clock so it can read more precisely the pushbutton 
    always @(posedge clk_in)
        begin
            count <= count + 1;
            if(count == 5_000_000)
                begin
                    count <= 0;
                    clk_out <= ~clk_out; //inverts the clock
                end
        end
     
endmodule
