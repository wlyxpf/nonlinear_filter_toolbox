function [variance,M] = var(p,vgrid,I)
% VAR evaluates variance or covariance matrix of random variable with point-mass pdf
%   variance = var(pmpdf)
%   [variance,mean] = var(pmpdf) returns both the variance and the mean
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

nx = get(p,'dim'); % dimension of the variable

if nargin < 3
    I = 1:length(p.values);
    if nargin < 2  % nargin == 1
        M = mean(p);	    % mean value
        vgrid = gridpts(p);
    else % nargin == 2
        M = mean(p,vgrid);  % mean value
    end
else     % nargin == 3
    M = mean(p,vgrid,I);	% mean value
end

if nx == 1  % 1-dim case

    if length(p.values) == size(vgrid,2)
        variance = get(p,'grmass') * (p.values(I).*vgrid(I)) * vgrid(I)' - M^2;
    elseif size(vgrid,2) == length(I)
        variance = get(p,'grmass') * (p.values(I).*vgrid) * vgrid' - M^2;
    end

else        % n-dim case

    sumsquare = zeros(nx);
    if length(p.values) == size(vgrid,2)
        for i = I
            sumsquare = sumsquare + vgrid(:,i)*vgrid(:,i)'*p.values(i);
        end
    elseif size(vgrid,2) == length(I)
        for i = 1:length(I)
            sumsquare = sumsquare + vgrid(:,i)*vgrid(:,i)'*p.values(I(i));
        end
    end
    variance = get(p,'grmass')*sumsquare - M*M';

end
