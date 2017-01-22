function q = isgaussian(p)
% NLNG/ISGAUSSIIAN Test on gaussianity of the noises W and V
% Q = ISGAUSSIAN(P)
%     Test on gaussianity of the noises
%     returns 1 if the noises are gaussian
%     returns 0 if the noises are not gaussian
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if isa(p.pw,'gpdf') && isa(p.pv,'gpdf') && isa(p.px0,'gpdf')
    q = 1;
else
    q = 0;
end


% CHANGELOG