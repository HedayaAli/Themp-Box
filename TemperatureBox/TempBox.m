%********************** set up **********************
clc
%clear all
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end
%close all
clc
disp('Serial Port Closed')

comPort='COM5';
s=serial(comPort);
set(s,'DataBits',8);
set(s,'StopBits',1);
set(s,'BaudRate',9600);
set(s,'Parity','none');

%----------
clear all
ardu = arduino()
ardu.AvailablePins()

ENAheater = 'D2';
IN1heater = 'D24';
IN2heater = 'D25';

ENBcooler = 'D3';
IN3cooler = 'D26';
IN4cooler = 'D27';

TempPin = 'A0';
PotPin = 'A10';
%--------------
configurePin(ardu,ENAheater,'PWM');
configurePin(ardu,IN1heater,'DigitalOutput');
configurePin(ardu,IN2heater,'DigitalOutput');
configurePin(ardu,ENBcooler,'PWM');
configurePin(ardu,IN3cooler,'DigitalOutput');
configurePin(ardu,IN4cooler,'DigitalOutput');

configurePin(ardu,TempPin,'AnalogInput');
configurePin(ardu,PotPin,'AnalogInput');


%************************** MAIN ***********************

TempVolt = [];
Temp = [];
PotVolt = [];
SetPoint = [];
t = [];

runtime = 60*2; % runtime in seconds

%------- HEATER ON ------
%writeDigitalPin(ardu,IN1heater,1);
%writeDigitalPin(ardu,IN2heater,0);
%writePWMVoltage(ardu,ENAheater,5);
%----------------------

%------- COOLER ON ------
writeDigitalPin(ardu,IN3cooler,0);
writeDigitalPin(ardu,IN4cooler,1);
writePWMVoltage(ardu,ENBcooler,5);
%----------------------

tic
while toc < runtime
t(end+1) = toc;
TempVolt(end+1) = readVoltage(ardu,TempPin);
Temp(end+1) = TempVolt(end)*100;
fprintf('Temp = %.2f',Temp(end))
fprintf('\n')
fprintf('TempVolt = %.2f',TempVolt(end))
fprintf('\n')

PotVolt(end+1) = readVoltage(ardu,PotPin);
SetPoint(end+1) = PotVolt(end)*2 + 20; % Range of SetPoints in Potentiometer
fprintf('SetPoint = %.2f',SetPoint(end))
fprintf('\n\n')
pause(1);
end


%------- LAMP OFF ------
writeDigitalPin(ardu,IN1heater,0);
writeDigitalPin(ardu,IN2heater,0);
writePWMVoltage(ardu,ENAheater,0);
%----------------------
%------- COOLER ON ------
writeDigitalPin(ardu,IN3cooler,0);
writeDigitalPin(ardu,IN3cooler,0);
writePWMVoltage(ardu,ENBcooler,0);
%----------------------

% MATLAB SETPOINT??? OR POTENTIOMETER? --> record potentiometer


% plotTitle = 'Arduino Data Log';  % plot title
% xLabel = 'Time (s)';     % x-axis label
% yLabel = 'Voltage (V)';      % y-axis label
% yMax  = 5;                          %y Maximum Value
% yMin  = 0 ;                      %y minimum Value
% plotGrid = 'on';                 % 'off' to turn off grid
% min = 1;                         % set y-min
% max = 2;                        % set y-max
% delay = 0.1;    
% legend1 = 'A0'% make sure sample faster than resolution 
% %Define Function Variables
% time = 0;
% data = 0;
% count = 0;
% %Set up Plot
% plotGraph = plot(time,data,'-r' )  % every AnalogRead needs to be on its own Plotgraph
% hold on                            %hold on makes sure all of the channels are plotted
% title(plotTitle,'FontSize',15);
% xlabel(xLabel,'FontSize',15);
% ylabel(yLabel,'FontSize',15);
% legend(legend1)
% axis([yMin yMax min max]);
% grid(plotGrid);
% tic
% while ishandle(plotGraph) %Loop when Plot is Active will run until plot is closed
%          dat = readVoltage(a, 'A0');; %Data from the arduino     
%          count = count + 1;    
%          time(count) = toc;    
%          data(count) = dat(1);         
%          %This is the magic code 
%          %Using plot will slow down the sampling time.. At times to over 20
%          %seconds per sample!
%          set(plotGraph,'XData',time,'YData',data);
%           axis([0 time(count) min max]);
%           %Update the graph
%           pause(delay);
%   end
