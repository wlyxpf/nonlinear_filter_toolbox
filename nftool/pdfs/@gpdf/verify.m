function res = verify(p)
% GPDF/VERIFY verify parameters GPDF
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


% get dimension of random variable
dim = get(p,'dim');

% get size of mean and variance
[Nm,Mm] = size(p.mean);
[Nv,Mv] = size(p.var);

if (Mm>1) | (Nm~=Nv) | (Nv~=Mv) | (dim~=Nm)
    % error in dimensions
    error('nft2:gpdf:bad_dim','Bad dimension of mean or variance');
    return
else
    % verify variance

    V = p.var;     % variance

    % must be symmetric
    if sum(sum(V' ~= V)) ~= 0
        error('nft2:gpdf:var_symm','Variance is not symmetric.');
        return
    end

    % ??? must be positive semidefinite
    % eig value must be real and >=0
    %
    [R,p] = chol(V);
    if (p ~= 0) & (~isempty(R))
        error('nft2:gpdf:var_posdef','Variance must be positive definite');
        return
    end

    % ??? must be regular
    %  if inv(V) == Inf
    %    error_msg('var_sing');
    %    return
    %  end

end

% OK

% CHANGELOG
