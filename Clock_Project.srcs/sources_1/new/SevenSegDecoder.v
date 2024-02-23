`timescale 1ns / 1ps


module SevenSegmentDisplay (
input [3:0]BCD_number,  //4 bits binary number
output reg [6:0]  seg7  // segments value
);

    always @(BCD_number) begin
    
         case (BCD_number) //GFEDCBA
             4'b0000: seg7 <= 7'b1000000; //0
             4'b0001: seg7 <= 7'b1111001; //1
             4'b0010: seg7 <= 7'b0100100; //2
             4'b0011: seg7 <= 7'b0110000; //3
             4'b0100: seg7 <= 7'b0011001; //4
             4'b0101: seg7 <= 7'b0010010; //5
             4'b0110: seg7 <= 7'b0000010; //6
             4'b0111: seg7 <= 7'b1111000; //7
             4'b1000: seg7 <= 7'b0000000; //8
             4'b1001: seg7 <= 7'b0011000; //9
             default: seg7 <= 7'b1000000;
         endcase
    end
    
endmodule