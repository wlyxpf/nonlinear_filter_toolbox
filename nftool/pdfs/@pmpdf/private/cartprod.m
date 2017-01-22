function vect = cartprod(argin)
% CARTPROD
%   The function computes the cartesian product of axis grids stored in
%   axgrids variable of the cell-array type. axgrids{i} is a vector of
%   grid points in the i-th state coordinate; i=1,...,n. The output of the
%   function is a n-times-N matrix containing grid points of dimension n
%   stored as column vectors; N is the total number of grid points and is
%   computed as the product of axis grid lengths.
%
%   The input argument can be either the axgrids variable itself, or an
%   object of class pmpdf

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if isa(argin,'pmpdf')
    axgrids = axisgrids(argin);
else
    axgrids = argin;
end
n = length(axgrids);
N = zeros (1,n);

for i=1:n
    N(i) = length(axgrids{i});
end

vect(1,:) = expand(axgrids{1}, prod(N(2:n)));

for i=2:n
    e = expand(axgrids{i}, prod(N(i+1:n)));
    vect = [vect; repmat(e,1,prod(N(1:i-1)))];
end
