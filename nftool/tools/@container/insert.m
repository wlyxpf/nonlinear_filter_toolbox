function p = insert(p,o)
% SETS the actual position of the P to O and moves one step ahead
% FUNCTION P = INSERT(P,O)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

p = set_cur(p,o); %insert object
p = mv_next(p);   %move to next position

% CHANGELOG 