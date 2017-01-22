function res = verify(p)
% GSPDF/VERIFY verify parameters GSPDF
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

means = p.means;

%get simension of each mebmer
for i = 1:p.n_members
  s(i) = length(means{i});
end

%checkiing if weights are positive
if (sum(find(p.weights<0))>0)
  error('nft2:gspdf:we_neg','Weights must be positive');
end


%compare them - must be same
if (max(s) ~= min(s))
  error('nft2:gspdf:nonscalar_match','Requires non-scalar arguments to  match in size.');
end

%check weights if their sum is one
if (abs(1-sum(p.weights)) >= p.n_members*eps)
  warning('nft2:gspdf:we_normal','Weights must be normalized');
end

%check each gpdf
pdfs = gpdfs(p);

% CHANGELOG
