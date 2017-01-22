function p = container(length)
%  CONSTRUCTOR OF THE CONTAINER OBJECT 
%  FUNCTION P = CONTAINER(LENGTH)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

p.pos = 1; %setting position in container
p.length = length; % setting length of the container

for i = 1:length
  p.cont{i} = struct([]); %creating container
end

p = class(p,'container');

% CHANGELOG
