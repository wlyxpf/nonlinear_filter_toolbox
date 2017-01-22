function p = mv_next(p)
% MOVES the actual position of the P forward
% FUNCTION P = MV_NEXT(P)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if p.pos < p.length % if not on the end pos
  p.pos = p.pos+1; %move pos forward
else
  p.pos = 1;  %move to the 1st pos in container
end


% CHANGELOG