module Digital_Clock(
input clk,            //clock of the FPGA 
      en,             //enable the clock start counting   
      reset,          //reset
      globalReset,    //this reset will reset all the states and options of the program
      B2,             //On/Off Settings
      B3,             //Toggle Hour and minutes Settings. Also, if is in Toggle Format Hour it will toggle 24/12 hours Format and if is inDaylight it will turn off and on the daylight saving
      B4,             //Increment if is in set hour or set minute. If is in alarm state(10) and Button 2 is on(1) it will postponed the alarm.
input [1:0]  mainState,        //this is to change from clock to chonometer to alarm
             secondaryState,   //This works to change configurations like change to modify the hour or min, or change 24/12 format or daylight saving configuration
output reg p,                  //this is the period and is to know in what period the time is it, if is in a.m. or p.m.
output [3:0] s1,               //seconds units
             s2,               //seconds tens
             min1,             //minutes units
             min2,             //minutes tens
             h1,               //hour units
             h2                //hour tens
);

//time display
// h2 h1: min2 min1

reg [5:0] hour = 0, min = 0, sec = 0; // this because in min and sec the large number is 60 so 2^6 = 64
reg [5:0] limit = 6'd11;              // this is for the 24/12 format configuration and it will change from 11 to 23
integer frequency_counter = 0;        //will count until the limit of the frequency that the Basys3 FPGA works
localparam frequency_limit = 100_000_000; //this is the frequency of the basys 3 
reg period = 1'b0;                      //to jnow if the time is in a.m or p.m when is in 12 hour format
reg check = 1'b0;                       //this verify if is the first time to enter on the daylight saving time

//This is for debuging
wire [3:0] sec1, sec2, m1, m2, hour1, hour2;
// Reset the clock
always @(posedge clk)
    begin  
        if(reset == 1'b1 && mainState == 2'b00 && en == 1'b0 || globalReset == 1'b1 && en == 1'b0)
            begin
                {hour,min,sec} <= 0;
                period <= 1'b0;
                check <= 1'b0;
            end
            
// Setting the time for the clock
        else if(mainState == 2'b00 && secondaryState == 2'b00 && B2 == 1'b1 && B3 == 1'b0 && B4 == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0) 
                if( min == 6'd59)
                    min <= 0;
                else 
                    min <= min + 1'd1;
        else if(mainState == 2'b00 && secondaryState == 2'b00 && B2 == 1'b1 && B3 == 1'b1 && B4 == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0) 
                if(hour == limit)
                    begin
                        if(limit == 6'd11)
                            period <= ~period;
                        hour <= 0;
                    end
                else 
                    hour <= hour + 1'd1;
                    
// 24 or 12 Format Hour
        else
        if(mainState == 2'b00 && secondaryState == 2'b01 && B2 == 1'b1 && B3 == 1'b0 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0)
            begin
                if(hour > 6'd11)
                    begin
                        hour <= hour - 6'd12;
                        period <= 1'b1;
                    end
                limit <= 6'd11;
            end 
        else if(mainState == 2'b00 && secondaryState == 2'b01 && B2 == 1'b1 && B3 == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0)
            begin 
                if(period == 1'b1)
                    begin
                        hour <= hour + 6'd12;
                        period <= 0;
                    end 
                limit <= 6'd23; 
            end
            
// Daylight Saving Time configuration
        else
        if(mainState == 2'b00 && secondaryState == 2'b10 && B2 == 1'b0 && B3 == 1'b0 && check == 1'b1 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0)
            begin
                if(limit == 6'd11 && hour == 6'd11 || limit == 6'd23 && hour == 6'd23)
                    begin
                        hour <= 0;
                        if(limit <= 6'd11)
                            period <= ~ period;
                    end                  
                else
                    hour <= hour + 1'd1;
                check <= 1'b0;
            end
        else if (mainState == 2'b00 && secondaryState == 2'b10 && B2 == 1'b0 && B3 == 1'b1 && check == 1'b0 && reset == 1'b0 && globalReset == 1'b0 && en == 1'b0)
            begin
                if(hour == 1'd0)
                    begin
                        if(limit == 6'd11)
                            begin
                                hour <= 6'd11;
                                period <= ~period;
                            end
                        else
                            hour <= 6'd23;
                    end
                else
                    begin
                        hour <= hour - 1;  
                    end
                check <= 1'b1;
            end
            
// Clock operation
        else     
        if(en == 1'b1)
                if(frequency_counter == frequency_limit)
                    begin
                        frequency_counter <= 0;
                        if(sec == 6'd59)
                            begin
                                sec <= 0;
                                if(min == 6'd59)
                                    begin
                                        min <= 0;
                                        if(hour == limit)
                                            begin 
                                                hour <= 0;
                                                if(limit == 6'd11)
                                                    period <= ~period;
                                            end
                                        else
                                            hour <= hour + 1'd1;
                                    end
                                else
                                    min <= min + 1'd1;
                            end
                        else
                            sec <= sec + 1'd1; 
                     end
                 else
                    frequency_counter <= frequency_counter + 1;
         p <= period;
    end   
    
///Instantiating the BCD modules to convert the numbers and display them on the seven segment display
BCD secondss(.clk(clk),.binary(sec), .tens(s2), .ones(s1));
BCD minutess(.clk(clk),.binary(min), .tens(min2), .ones(min1));
BCD hours(.clk(clk),.binary(hour),  .tens(h2), .ones(h1));
 
endmodule