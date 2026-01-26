clear;
clc;
%%Conditional Operations
SAVEALL =1; %1-Save, 0-Don't Save
RealData=1; %UseReal Data or  not
PLTRealData=1; %Plot Real Data or  not

%Runing Scripts
BuckDesign_modinit;
% Kicalc_buck = Ki_buck
% Kpcalc_buck =Kp_buck;
Buck_GM_PM_analysis;
BoostDesign_modinit;
Tsim_fullsys = 50e-6; % Simulation step size
%% Configure Input Data
if RealData % If using experimental Data
    ImportedData = load("RealData\WLTC_HESS_data.mat");
% 
%     Tini = ImportedData.WLTC_data_HESS.time(1);
%     Tfin = ImportedData.WLTC_data_HESS.time(end); % 10 seconds simulation time
% 
%     indx = (ImportedData.WLTC_data_HESS.time >= Tini & ...
%             ImportedData.WLTC_data_HESS.time <= Tfin);
% 
%     Tsim_array = 0:Tsim_fullsys:(Tfin - Tini);
% 
%     IFC_Real = interp1( ImportedData.WLTC_data_HESS.time(indx), ...
%                         ImportedData.WLTC_data_HESS.iFC(indx)./15, ...  
%                         Tsim_array + Tini );
%                     %/15 to guarentee a max current of 5A



        Tini = 1500;
    Tfin = Tini + 200; % 10 seconds simulation time

    indx = (ImportedData.WLTC_data_HESS.time >= Tini-0.2 & ...
            ImportedData.WLTC_data_HESS.time <= Tfin+0.2);

    Tsim_array = 0:Tsim_fullsys:(Tfin - Tini);

    IFC_Real = interp1( ImportedData.WLTC_data_HESS.time(indx), ...
                        ImportedData.WLTC_data_HESS.iFC(indx)./15, ...
                        Tsim_array + Tini );
                                        %/15 to guarentee a max current of 5A
    if PLTRealData
        hold on;
        figure(537);
    
        plot(Tsim_array,IFC_Real);
            title('IFC-REAL');
            hold off;
    end

IFC_Real_Matrix= [Tsim_array(:),IFC_Real(:)];
else
    IFC_Real_Matrix= [zeros(1,100)',zeros(1,100)'];
end