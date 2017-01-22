function res = verify(p,ferr)
% EPDF/VERIFY verify parameters EPDF
% ferr = 1 >>> error
% ferr = 0 >>> warning
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% get dimension of random variable
dim = get(p,'dim');
S = p.samples;

%get dimension of the samples
for i = 1:length(p)
    l(i) = size(S(:,i),1);
end

%comparing size of samples
if (max(l) ~= min(l))
    error('nft2:epdf:samples_length','The samples must have the same length');
end


% checking weights with samples
[Nw,Mw] = size(p.weights);
[Nx,Mx] = size(S);

if (Nw>1) | (Mx~=Mw) | (Nx ~= dim)
    % error in dimensions
    error('nft2:epdf:bad_dim','Bad dimension of mean or variance');
end


%check weights if their sum is one
if ((sum(p.weights) - 1)>(Mw*eps))
    error('nft2:epdf:we_normal','Weights must be normalized');
end

% CHANGELOG
