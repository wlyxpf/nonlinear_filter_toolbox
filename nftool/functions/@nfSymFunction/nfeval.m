function [val] = nfeval(p,point)
% NFEVAL - evaluating the function of the nffunction object p
%   

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if length(point) ~= p.nvar
    error('nft2:nfSymFunction:wrongNumberOfParameters','Wrong number of input parameters');
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filling all the variables with values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:p.nvar              % cycle trought all variables
        expr = [p.parameters{i},'=[point(i)];']; % coverting assigning
        % expression to string
        eval(expr);               % evaluation of the expresion
    end
    val = eval(p.nffun);          % evaluation of the function
end
