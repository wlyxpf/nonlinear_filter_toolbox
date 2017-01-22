function K = kalman_gain(p,Vp,H,R,delta)
% KALMAN_GAIN - computation of Kalman gain
% FUNCTION K = KALMAN_GAIN(p,Vp,H,R,delta)

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

K = Vp * H' * inv(H * Vp * H' + delta * R * delta');
