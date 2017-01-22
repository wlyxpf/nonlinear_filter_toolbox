function pdf_pred = agd(pdf,system,params,u,eta,I)
% AGD creates a grid for the point-mass filter using the anticipative
%   approach.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

Q  = var(system.pw);  % state noise covariace matrix
nx = system.nx;
nu = system.nu;
nw = system.nw;
f  = system.f;
x  = system.x;

if isa(pdf,'pmf') && (nargin > 4) %*** Grid design at the prediction step

    % mean and covariance matrix
    [C_eta,m_eta] = var(pdf,eta,I);
    C_eta = C_eta + Q;
    % Jordan decomposition
    [T,D]  = eig(C_eta);
    sqrtD  = sqrt(diag(D));
    sqrtQT = sqrt(diag(T'*Q*T));

else                              %*** Grid design at the initialization step

    % mean and covariance matrix
    m_eta = mean(pdf);
    C_eta = var(pdf);
    % Jordan decomposition
    [T,D]  = eig(C_eta);
    sqrtD  = sqrt(diag(D))';
    sqrtQT = sqrt(diag(T'*Q*T))';
    % Subsidiary grid for computation of max abs Jacobian
    ngpts = 11*ones(1,nx);
    mass  = 2*params.b * sqrtD./ngpts;

    axgrid = cell(nx);
    for l = 1:nx
        axgrid{l} = mass(l) * ([1:ngpts(l)] - (ngpts(l)+1)/2);
    end
    eta = T*cartprod(axgrid) + repmat(m_eta,1,prod(ngpts));

end

% Maximum absolute value of Jacobian of the state function
if isempty(params.fixedNGPTS)
    if islinear(f,x)  % Jacobian for linear system
        if isa(system,'lga')
            jacob = abs(det(system.F));
        else
            jacob = abs(det( nfdiff(f, [zeros(1,nu); zeros(nx,1); zeros(nw,1)], x) ));
        end
    else            % Jacobian for nonlinear system
        jacob = 0;
        if nargin < 4
            u = zeros(1, nu);
        end
        zero_w = zeros(nw,1);
        for i = 1:size(eta,2)
            if system.nu>0
                abs_detF = abs(det( nfdiff(f, [u; eta(:,i); zero_w], x) ));
            else
                abs_detF = abs(det( nfdiff(f, [eta(:,i); zero_w], x) ));
            end
            if abs_detF > jacob
                jacob = abs_detF;
            end
        end
    end
    % Adaptive number of grid points
    ngpts = max( 7, ceil( params.b/params.gamma*jacob^(1/nx) * sqrtD./sqrtQT  ) );
else
    % Fixed number of grid points
    ngpts = params.fixedNGPTS;
end

mass  = 2*params.b * sqrtD./ngpts;

pdf_pred = pmpdf(mass, ngpts, ones(1,prod(ngpts)), T, m_eta);  % Create the predictive pdf object (pdf values are identical for this moment)
