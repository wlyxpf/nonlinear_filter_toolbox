function display(p)
% DISPLAY - NFFUNCTION/DISPLAY Command window display of nffunction
%
% p         ... object of the class nfSymFunction
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

disp(' ');
disp([inputname(1),' = ',p.nffun]);
disp(' ');
disp('A = ');
disp(p.parametersValue(:,p.nu+1:p.nu+p.nx));
disp(' ');
disp('B = ');
disp(p.parametersValue(:,1:p.nu));
disp(' ');
disp('Gamma = ');
disp(p.parametersValue(:,(p.nu+p.nx+1):(p.nu+p.nx)+p.nxi));

% CHANGELOG
