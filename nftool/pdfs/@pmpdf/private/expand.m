function expandedArray=expand(array,n)
%EXPAND	Expand a vector by repeating its elements
%	expand(array,n) will expands the array to length that is n times
%	its original length. It is completed by repeating each element 
%   in the array n times.

% Nonlinear Filtering Toolbox version 2.0rc2
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if (n<=0)||(rem(n,1)~=0)
   error('nft2:pmpdf:notPosInt','N not a positive integer');
end

[minDimension,minDimIndex] = min(size(array));
if minDimension ~= 1
   error('nft2:pmpdf:inputNotVector','Input array that should be expanded is not a vector');
end

% Prealocate data structure for the expanded vector
arrayLength = length(array);
if minDimIndex == 1
    expandedArray = zeros(1,arrayLength*n);
else
    expandedArray = zeros(arrayLength*n,1);
end

offsetIndex = 0:n:(arrayLength-1)*n;

for i=1:n
    expandedArray(offsetIndex+i)=array;
end
