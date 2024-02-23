`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 03:31:07 AM
// Design Name: 
// Module Name: BCD
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


module BCD(
    input clk,
    input [5:0] binary, //12 bit data that would come-in
    output reg [3:0] //thous, //output thousands
                     //hund,  //hundreds
                     tens,    //tens
                     ones     //ones
    );
    
    reg [5:0] bcd_data = 0;
    always @(binary) //1234 
        begin
            bcd_data <= binary; //1234 binary
//            thous <= bcd_data/1000; //1234/1000 = 1
//            bcd_data <= bcd_data%1000; //1234%1000 = 234
//            hund <= bcd_data/100; //234/100 = 2
//            bcd_data <= bcd_data%100; //234%100 = 34
            tens <= bcd_data/10; //34/10 = 3
            ones <= bcd_data%10; //34 / 10 = 4
        end
endmodule
