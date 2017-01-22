function m = mean(p,vgrid,I)
% MEAN evalutes mean value of random variable with point-mass pdf
%   m = mean(pmpdf)
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if nargin < 2
    vgrid = gridpts(p);
end

if nargin == 3
    if length(p.values) == size(vgrid,2)
        m = get(p,'grmass') * sum( vgrid(:,I)' .* repmat(p.values(I),get(p,'dim'),1)' )';
    elseif size(vgrid,2) == length(I)
        m = get(p,'grmass') * sum( vgrid' .* repmat(p.values(I),get(p,'dim'),1)' )';
    else
        error('nft2:pmpdf:inputArgsMismatch','Input arguments size mismatch.')
    end
else
    m = get(p,'grmass') * sum( vgrid' .* repmat(p.values,get(p,'dim'),1)' )';
end
