function [chi,w]= msp(x, P, kappa, nx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Method msp for the calculation of sigma-points, called from methods for prediction, filtration and smoothing.
%   For standard estimation algorithms.
%
%   function [ch,w]=msp(x,P,kappa,nx)
%   input parameters                    - x - mean value,
%                                       - P - covariance matrix,
%                                       - kappa – parameter for distribution of sigma-points,
%                                       - nx - dimension of x
%
%   output parameters                   - chi - calculated point
%                   			        - w -  weight of the point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

nx = length(x);

pom = chol((nx+kappa)*P);

chi(:,1) = x;
chi(:,2:2*nx+1) = x(:,ones(1,2*nx)) + [pom', -pom'];

w(1)=kappa/(nx+kappa);
w(2:2*nx+1)=0.5/(nx+kappa);% Nonlinear Filtering Toolbox version 2.0-rc4
