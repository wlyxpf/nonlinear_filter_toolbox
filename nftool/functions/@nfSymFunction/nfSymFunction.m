function p = nfSymFunction(varargin)
% FUNCTION - nfSymFunction constructor
%
% The nfSymFunction is supposed in form f=f(x,u,xi)
%         where - x denotes multivariate state
%                 u denotes multivariate input/control
%                 xi denotes multivariate noise
%
% Objects of defined by nfSymFunction makes it possible to define 
% multivariate functions using Symbolic toolbox facilitating use of the 
% toolbox (e.g. user doesn't have to deduce the derivatives)
%   
% Example :
% 
% f = nfSymFunction('x^2+2*u+w^2','u','x','w') 
% creates an nfSymFunction object describing following nonlinear
% multivariate function
%
% f(x,u,w) = x^2 + 2*u + w^2 
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 0
        error('nft2:nfSymFunction:not_enough_params','Not enough input parameters!');
    case 1
        if isa(varargin{1},'nfSymFunction')
             p = varargin{1};
         else
             error('nft2:nfSymFunction:not_nfsymfunction','Input argument is not a nfSymFunction object');
        end
    case {3,4}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1st arg: transition equation
        % 2nd arg: list of input variables (comma separated)
        % 3th arg: list of state variables (comma separated)
        % 4th arg: list of noise variables (comma separated)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Extract the symbolic names of variables and store their dimension
        if nargin==4                      % is there an input variable?
            p.u = all_vars(varargin{2});
            p.x = all_vars(varargin{3});
            p.xi = all_vars(varargin{4});
        else                              
            p.u = {};                     % no input variables
            p.x = all_vars(varargin{2});
            p.xi = all_vars(varargin{3});
        end
        p.nu = size(p.u,2);         % determine size of the input
        p.nx = size(p.x,2);
        p.nxi = size(p.xi,2);
    
        p.parameters = [ p.u p.x p.xi ];% put the variables together
        p.nvar = length(p.parameters);  % number of variables = number 
                                        % of partial derivatives

                                        
        p.nffun = varargin{1};          % store the string defining function

        f = sym(p.nffun);               % make symbolic function from 
                                        % the string stored in fun
        [nf1 nf2] = size(f);            % get the dimensions 
                                        % of the created symbolic function
        if nf2 == 1
            p.mappingDimension = nf1;
        else
            error('nft2:nfSymFunction:wrongMappingDimension','The mapping has incorrect dimension');
        end
        
        % determine the MATLAB release number
        release_number = str2num(version('-release'));
        
        for i = 1:p.nvar                % derive the symbolic function with 
                                        % respect to specific variable  
            symtmp = jacobian(f,p.parameters{i});
            
            % test whether the function is linear with respect to current varible
            if isempty(findsym(symtmp))
                p.linear{i} = 1;        % no symbolic varible => linear
            else
                p.linear{i} = 0;        % contains symbolic varible 
                                        % => function is nonlinear
            end

            %=============================================================
            % create cell array of strings containing partial derivatives
            % it is necesary to remove prefixed description and convert 
            % commas to semicolons
            %=============================================================
            if ( isempty(release_number) || release_number>13 )
                p.derivative{i} = strrep(char(symtmp),'matrix','');
            else
                p.derivative{i} = strrep(char(symtmp),'array','');
            end
            %if p.nf2 == 1
            %    p.derivative{i} = strrep(p.derivative{i},',',';');
            %end
            %=============================================================
        end


        p.secondDerivative = [];    % this holds the second partial derivatives
        
        NFFUNCTION = nfFunction(p.nffun,p.mappingDimension,p.parameters,p.nvar,p.nu,p.nx,p.nxi,p.linear);

        p = class(p,'nfSymFunction',NFFUNCTION);
    otherwise
        error('Wrong number of input arguments');
end
