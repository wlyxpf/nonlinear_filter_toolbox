function s = sampleset(p,n)
% SAMPLE sampling from general pdf
% S = SETSAMPLE(P,N) generates N sample from gpdf object P
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

for i=1:n
    s(:,i) = sample(p);
end


% CHANGELOG