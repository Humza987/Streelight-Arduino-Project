% Name: Humza Inam
% Date: Dec 8th, 2020
clear all; close all;
a = arduino('COM3','Uno');
Sample_Size = 1000;
y=1;
stop=false;
while(y)
    for i = 1:Sample_Size
        if(~stop)
            if (i>5)
                u=i-5;
                Sound_Voltage(i) = readVoltage(a, 'A2');          % Reading Sound Voltages
                Avg_Sound_Voltage(u)=mean(Sound_Voltage(u:u+5));  % Taking the mean of sound values
                Light_Voltage(i) = readVoltage(a, 'A0');          % Measuing Light Voltages
                Light_Length(i) = length(Light_Voltage);
                Light_Length2(u) = length(Light_Voltage);
                if(Light_Voltage(i)<=1.5)                      % if light sesnor is less
                    LED_Voltage(i) =4-Light_Voltage(i) ;       % LED brightens
                    if(Avg_Sound_Voltage(u)>=1)                % If average sound voltage geos above 1 Volt it turn LED on completely
                        LED_Voltage(i)=5;
                    end
                else                                           % if Light sesnor is high
                    LED_Voltage(i) = 3.64-Light_Voltage(i);    % LED dims down
                end
                writePWMVoltage(a,'D3',LED_Voltage(i));        % Uses the PWM function to control the brightness of the LED
                subplot(311);
                plot(Light_Length,Light_Voltage,'k');
                title('Light Sensor Voltage Values');
                xlabel('Sample Number');                        % Plotting and labelling of the graphs
                ylabel('Voltage');
                xlim([-0.1,Light_Length(i)]);
                ylim([-0.2,5.2]);
                subplot(312);
                plot(Light_Length,LED_Voltage,'r');
                title('LED Voltage Values');
                xlabel('Sample Number');
                ylabel('Voltage');
                xlim([-0.1,Light_Length(i)]);
                ylim([-0.2,5.2]);
                subplot(313);
                plot(Light_Length2,Avg_Sound_Voltage,'g');
                title('5 Point Moving Average (Sound)');
                xlabel('Sample Number');
                ylabel('Voltage');
                xlim([-0.1,Light_Length(u)]);
                ylim([-0.2,5.2]);
            end
            stop = readDigitalPin(a,'D6');                    % using the button to stop the program
        end
    end
    writePWMVoltage(a,'D3',0);                                % turn off LED and the while loop
    y=0;
end
