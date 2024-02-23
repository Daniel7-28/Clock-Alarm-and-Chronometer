`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 03:41:21 PM
// Design Name: 
// Module Name: ToggleButtons
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


module ToggleButtons(
    input button,           //Button that will toggle the output
    output button_out   //the output toggled
    );
    reg button_bar = 0;
    always@(posedge button)
        begin
            if(button_bar == 1'b0 && button == 1'b1)
                button_bar <= 1'b1;
            else
                button_bar <= 1'b0;   
        end
        assign button_out = button_bar;
endmodule
