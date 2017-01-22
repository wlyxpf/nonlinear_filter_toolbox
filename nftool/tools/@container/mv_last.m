function p = mv_last(p)
% MOVES the actual position of the P backward
% FUNCTION P = MV_LAST(P)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if p.pos > 1 % if not on 1st pos
  p.pos = p.pos-1; %move back
else 
  p.pos = p.length; %move back to last pos in container
end


% CHANGELOG