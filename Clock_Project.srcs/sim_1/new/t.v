`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 11:07:26 PM
// Design Name: 
// Module Name: t
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


module t(
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 05:57:04 PM
// Design Name: 
// Module Name: Test
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


module t();

reg clk, B1, B2, B3, B4, B5, SW1, SW2, SW3, SW4;
wire p, btwo, bthree, Buzzer, alarmPeriod, RGBLEDs;
wire [1:0] sstate, mstate;
wire [6:0] seg;
wire [3:0] an;
wire [7:0] led;


//System(input clk, B1, B2, B3, B4, B5, SW1, SW2, SW3, SW4, output p, btwo, bthree, Buzzer, alarmPeriod, RGBLEDs, output [1:0] sstate, mstate, output [6:0] seg, output [3:0] an, output [7:0] led);
SystemWithoutDebouncer CUT(clk, B1, B2, B3, B4, B5, SW1, SW2, SW3, SW4, p, btwo, bthree, Buzzer, alarmPeriod, RGBLEDs, sstate, mstate, seg, an, led);

initial clk = 1;        //clock
initial B1 = 0;         //change from state to state
initial B2 = 0;         //Turn on/off settings
initial B3 = 0;         //change hour/minutue configuration - 24/12 hour format - turn off on the daylight saving time
initial B4 = 0;         //increment the hour/minutes
initial B5 = 0;         //start/stop the chonometer
initial SW1 = 0;        //enable the clock
initial SW2 = 0;        //enable the alarm
initial SW3 = 0;        //reset current state only
initial SW4 = 0;        //reset all states

always #10 clk = ~clk;

initial begin
//SW4 = 1; #100;
//SW4 = 0; #100;

//Testing the clock
//Setting the time
//changin state 
// #163800 B1 = 1; //#163800;
// #163800 B1 = 0; //#1000;

#20 B1 = 1; #10;
B1 = 0; #10;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B1 = 1; #100;
//B1 = 0; #100;
//B2 = 1; #41000;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4= 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B3 = 1; #100;
//B3= 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4 = 0; #100;
//B4 = 1; #100;
//B4= 0; #100;
//SW1 = 1; #100;


end
endmodule

