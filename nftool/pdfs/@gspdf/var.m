function variance = var(p)
% VAR - evaluates variance of Gaussian mixture
%   variance = var(gspdf)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

variance = 0;                            % initialize mean of
                                         % Gaussian mixture
mean_p = mean(p);                        % get mean of the Gaussian
                                         % mixture

for i = 1:p.n_members                    % evaluate the variance
    variance = variance+p.weights(i)*(p.variances{i}+(mean_p-p.means{i})*(mean_p-p.means{i})');
end
