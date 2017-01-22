function p = set_pos(p,pos)
% SETS the actual position of the P to POS
% FUNCTION P = SET_POS(POS)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


if (pos >= 1) && (pos <= p.length) % if pos is in bounds
  p.pos = pos; %set pos
else
  error('nft2:container:pos_oor','The position is out of range');
end

% CHANGELOG
