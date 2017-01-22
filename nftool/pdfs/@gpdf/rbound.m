function r = rbound(p,m)
% LBOUND - upper bound for numerical integration and plotting
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

for i=1:p.general_pdf.dim
    r(i) =  p.mean(i) + m*sqrt(p.var(i,i));
end
