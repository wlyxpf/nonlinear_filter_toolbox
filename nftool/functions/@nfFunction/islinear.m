function [linearity] = islinear(p,variables)
% islinear - this method tell whether the object represents linear function
%   
% p         ... object of the class nffunction
% variables ... the linearity is determined with respect to "variables"
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% FIXME: implement missing test of input arguments

subval = 1;       % appriori suppose the multivariate function as nonlinear
i = 1;            % set the index of variables to the first one

while (i<=length(variables)) & (subval == 1)
  % look for index of the variable within the cell of parameters
  j = 1;
  while ~strcmp(p.parameters{j},variables{i})
    j = j + 1;
    if j > p.nvar
      error('nft2:nfFunction:incorrectVariableSpecification','Incorrect variable specification'); 
    end
  end
 
  % make logical AND of the information about linearity of the multivatiate 
  % function with respect to current variable
  subval = subval * p.linear{j}; 
  
  i = i + 1;      % take next variable
end

linearity = subval;

% CHANGELOG
