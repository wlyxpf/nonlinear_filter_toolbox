function mean = mean(p)
% MEAN - evalutes mean value of Gaussian mixture
%   mean = mean(gspdf)
%
%   \hat{x}_k=\sum_{i=1}^{\xi_k}\alpha_{ki}\hat{x}_{ki}
%
%
% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


mean = 0;                              % initialize mean of Gaussian mixture
for i = 1:p.n_members                  %
    mean = mean+p.weights(i)*p.means{i}; % evaluate the mean
end
