function V = riccati(p,Vp,K,H,R,delta)
% RICCATI - Riccati solution
% FUNCTION V = RICCATI(p,Vp,K,H,R,delta)

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

I = eye(size(Vp,1));
V = (I - K * H) * Vp * (I - K * H)' + K * (delta * R * delta') * K';
