clear;
clc;
%%Conditional Operations
SAVEALL =0; %1-Save, 0-Don't Save
RealData=1; %UseReal Data or  not
PLTRealData=1; %Plot Real Data or  not

%Runing Scripts
BuckDesign_modinit;
Buck_GM_PM_analysis;
BoostDesign_modinit;
Run_Sim_PAC;
Plot_Save_PAC;
