function v = evaluate(p,points)
% EVALUATE evaluates gspdf
% V = EVALUATE() evaluate given gspdf at given points
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


s = zeros(1,size(points,2));
for i = 1:p.n_members
    s = s + evaluate(gpdf(p.means{i},p.variances{i}),points) * p.weights(i);
end;
v = s;

% CHANGELOG