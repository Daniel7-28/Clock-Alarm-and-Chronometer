`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 09:46:17 PM
// Design Name: 
// Module Name: D_FF
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


module D_FF(
    input clk,      //slow clock
    D,              //pushbutton
    output reg Q,   //output Q
    Qbar            //output Qbar
    );
    
    //This works like a Normal D Flip - FLop
    always@(posedge clk)
    begin
        Q <= D;
        Qbar <= ~Q;
    end
endmodule
