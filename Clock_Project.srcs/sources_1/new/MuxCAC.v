`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2023 02:11:17 PM
// Design Name: 
// Module Name: MuxCAC
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


module MuxCAC(
    input [1:0] option,                                     //choose which input will pass to the output
    input [3:0] s1_c, s2_c, m1_c, m2_c, h1_c, h2_c,         //clock outputs 
                s1_ch, s2_ch, m1_ch, m2_ch, h1_ch, h2_ch,   //Chronometer outputs
                s1_a, s2_a, m1_a, m2_a, h1_a, h2_a,         //Alarm outputs
            
    output reg [3:0] s1, s2, m1, m2, h1, h2                 //outputs to be choose
    );
    
    always@(option, s1_c, s2_c, m1_c, m2_c, h1_c, h2_c, s1_ch, s2_ch, m1_ch, m2_ch, h1_ch, h2_ch, s1_a, s2_a, m1_a, m2_a, h1_a, h2_a)
        case(option)
            2'b00: begin
                    s1 <= s1_c;
                    s2 <= s2_c;
                    m1 <= m1_c;
                    m2 <= m2_c;
                    h1 <= h1_c;
                    h2 <= h2_c;
                   end
           2'b01: begin
                    s1 <= h1_ch;
                    s2 <= h2_ch;
                    m1 <= s1_ch;
                    m2 <= s2_ch;
                    h1 <= m1_ch;
                    h2 <= m2_ch;
                  end
          2'b10: begin
                    s1 <= s1_a;
                    s2 <= s2_a;
                    m1 <= m1_a;
                    m2 <= m2_a;
                    h1 <= h1_a;
                    h2 <= h2_a;
                 end
         default: begin
                    s1 <= s1_c;
                    s2 <= s2_c;
                    m1 <= m1_c;
                    m2 <= m2_c;
                    h1 <= h1_c;
                    h2 <= h2_c;
                  end     
        endcase
endmodule
