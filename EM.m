%For Comprehensive Research Support, Including Codes, Scripts, Simulink Models,
%Documentation, Assignments, Presentations, and Continuous Online Mentorship with
%(UG/PG/PhD) Throughout Your Research Journey:
%Confidentiality of your project is guaranteed, ensuring your work remains secure and private.
%Contact:     SACHIN S. WAGH                Email:             ssw.aws.official@gmail.com
%Phone:        (+91) 9403423640                Time Zone:     India
%% PROJECT: Electric Vehicle (EV): An Energy Management of Battery - 
%% PEM Fuel Cell (PEMFC) Hybrid Energy Storage.
%% Main Reference Paper
% Z. Mokrani and D. Rekioua and N. Mebarki and T. Rekioua and S. Bacha, 
% “Proposed energy management strategy in electric vehicle for recovering power excess 
% produced by fuel cells”, 
% International Journal of Hydrogen Energy, vol. 42, no. 30, pp. 19556-19575, 2017.
% https://www.sciencedirect.com/science/article/pii/S0360319917324205
%_____________________________________________________________________

clear;
close all;

% Define SOC limits
SOCmin = 30;
SOCmax = 90;

% Inputs
SOC = input('Enter SOC = ');
PFC = input('Enter PFC = ');
PLOAD = input('Enter PLOAD = ');

% Power difference
delP = PFC - PLOAD;

% Mode and control logic
if delP == 0
    % Mode 3: No power exchange
    Mode = 3;
    K1 = 0; K2 = 1; K3 = 0; K4 = 0;

elseif delP > 0  % Surplus Power Available (PFC > PLOAD)
    if PLOAD == 0
        % Mode 8: Idle (no load, fully supplied)
        Mode = 8;
        K1 = 0; K2 = 0; K3 = 0; K4 = 1;

    elseif SOC < SOCmax
        % Mode 1: Battery Charging
        Mode = 1;
        K1 = 1; K2 = 1; K3 = 0; K4 = 0;

    else
        % Mode 7: Bypass excess power (battery full)
        Mode = 7;
        K1 = 0; K2 = 1; K3 = 0; K4 = 1;
    end

elseif delP < 0  % Power Deficit (PFC < PLOAD)
    if SOC > SOCmin
        if PFC == 0
            % Mode 4: Pure battery discharge
            Mode = 4;
            K1 = 0; K2 = 0; K3 = 1; K4 = 0;
        else
            % Mode 2: Hybrid supply (PFC + battery)
            Mode = 2;
            K1 = 0; K2 = 1; K3 = 1; K4 = 0;
        end

    elseif PFC == 0
        % Mode 6: Total shutdown (no power sources)
        Mode = 6;
        K1 = 0; K2 = 0; K3 = 0; K4 = 0;

    else
        % Mode 5: Only PFC supports load (battery at SOCmin)
        Mode = 5;
        K1 = 1; K2 = 0; K3 = 0; K4 = 0;
    end
end

% Output the selected mode and switches
fprintf('Selected Mode = %d\n', Mode);
fprintf('K1 = %d, K2 = %d, K3 = %d, K4 = %d\n', K1, K2, K3, K4);