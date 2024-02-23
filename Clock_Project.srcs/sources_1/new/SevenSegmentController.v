`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 02:41:14 AM
// Design Name: 
// Module Name: SevenSegmentController
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

//THIS MODLUE IS FOR TURN ON THE 4 SEVEN SEGMENT DISPLAYS IN 
//A FREQUENCY THAT THE EY CAN'T DETECT THE DIFFERENCE WHEN IS ON AND OF

module SevenSegmentController(
    input       clk,        //clock 
                clr,        //reset
    input [3:0] in1,        //values that wil be display in the first seven segment display from left to right
                in2,        //values that wil be display in the second seven segment display from left to right
                in3,        //values that wil be display in the third seven segment display from left to right
                in4,        //values that wil be display in the fourth seven segment display from left to right  
                  
    output reg [6:0] seg,   //segments 
    output reg[3:0] an      //anodes   
    );
    
    wire [6:0] seg1, seg2, seg3, seg4;
    reg [12:0] segclk;  //= 13'b1_111_111_111_110; //for turning segment display one by one on the board
    
    localparam LEFT = 2'b00, MIDLEFT = 2'b01, MIDRIGHT = 2'b10, RIGHT = 2'b11;
    reg [1:0] state = LEFT;
    //WHEN THE POSITIVVE EDGE OF THE CLOCK ARRIVE THE COUNTERS GOES UP BY 1
    always @(posedge clk or posedge clr) // or posedge clr
        begin
            segclk <= segclk+1'b1;

    
//    always @(posedge segclk[12] or posedge clr)
//        begin
            if(clr ==1)
                begin 
                    seg <= 7'b1000000;
                    an <= 4'b0000;
                    segclk <= 13'b1_111_111_111_110;
                    state <= LEFT;
                end
            else if(segclk == 13'b1_111_111_111_111)
                begin
                    segclk <= 13'b0_000_000_000_000;
                    case(state)
                        LEFT:
                            begin
                                seg <= seg1;
                                an <= 4'b0111;
                                state <= MIDLEFT;
                            end    
                        MIDLEFT:
                            begin
                                seg <= seg2;
                                an <= 4'b1011;
                                state <= MIDRIGHT;
                            end 
                        MIDRIGHT:
                            begin
                                seg <= seg3;
                                an <= 4'b1101;
                                state <= RIGHT;
                            end 
                        RIGHT:
                            begin
                                seg <= seg4;
                                an <= 4'b1110;
                                state <= LEFT;
                            end
                        default:
                            begin
                                seg <= seg1;
                                an <= 4'b0111;
                                state <= MIDLEFT;
                            end
                    endcase
                end 
            end           
    
    //Seven segment display modules            
    SevenSegmentDisplay Left(in1, seg1);     
    SevenSegmentDisplay MidLeft(in2, seg2);   
    SevenSegmentDisplay MidRight(in3, seg3);   
    SevenSegmentDisplay Right(in4, seg4);  
    
endmodule
