`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 12:24:17 PM
// Design Name: 
// Module Name: BCDButton
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


module BCDButton(
    input clk,
          reset,
          reset2,
          button1,
          button2,
    output reg [1:0] mainState,
                 secondaryState
    );
    reg [1:0] mstate = 2'b00, sstate = 2'b00;
    always@(posedge clk)
        begin
            if(reset == 1'b1)
                begin
                    mstate <= 2'b00;
                    sstate <= 2'b00;
                end
            else
            if (reset2 == 1'b1)
                sstate <= 2'b00;            
            if(button1 == 1'b1 && button2 == 1'b0)
                begin
                    if(mstate == 2'b10)
                        mstate <= 2'b00;
                    else
                        mstate <= mstate + 1'b1;
                    sstate <= 2'b00;
                end
            else 
            if(button1 == 1'b1 && button2 == 1'b1)
                if(sstate == 2'b10)
                    sstate <= 2'b00;
                else
                    sstate <= sstate + 1'b1;
    mainState <= mstate;
    secondaryState <= sstate;  
        end
endmodule
