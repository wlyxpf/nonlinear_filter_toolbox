function p = gspdf(varargin)
% GSPDF gspdf class constructor
% P = GSPDF(W1,MEAN1,VAR1,W2,MEAN2,VAR2, ...)
%     creates a gspdf object with parameters P=SUM Wi*N{Qi;MEANi,VARi}
% P = GSPDF(W1,GPDF1,W2,GPDF2, ...)
%     creates a gspdf object with parameters P=SUM Wi*GPDFi
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%****************************************************************************
%******* If single argument of class gspdf, return it ***********************
%****************************************************************************
if nargin == 1
    if isa(varargin{1},'gspdf');
        p = varargin{1};
    elseif isa(varargin{1},'gpdf');
        p = gspdf(1,varargin{1});
    else
        error('nft2:gspdf:mb_gpdf','Must be an object of the gpdf class');
    end
else
    %********************** Even number of parameter ****************************
    %*** compose Gaussian pdf mixture form pairs of weights and Gaussian pdfs ***
    %****************************************************************************
    if (mod(nargin,2) == 0) && isa(varargin{2},'gpdf')
        dimension = get(varargin{2},'dim');            % Determine dimesion of
        % parameters of first
        p.n_members = floor(nargin/2);                 % Set the number of terms
        % in the mixture
        p.means = cell(p.n_members,1);                 % initialization of cell
        % of means
        p.variances = cell(p.n_members,1);             % initialization of cell
        % of variances
        for i=1:p.n_members
            p.weights(i) = varargin{2*i-1};              % Set weight of i-th
            % mixture memberif
            if get(varargin{2*i},'dim') == dimension     % check whether the
                % dimension of current
                % term comply
                p.means{i} = mean(varargin{2*i});            % assign the mean and
                p.variances{i} = var(varargin{2*i});         % variance of Gaussian pdf
            else
                error('nft2:gspdf:gpdf_match','Requires gpdf to match in size');
            end
        end
    else
        %****************************************************************************
        %*** compose Gaussian mixture form weights, means and covariances triplets **
        %****************************************************************************
        if (mod(nargin,3) == 0),
            if (nargin == 3) && iscell(varargin{2}) && iscell(varargin{3}),
                p.n_members = length(varargin{1});           % set the term number
                p.means     = varargin{2};                   % assign means
                p.variances = varargin{3};                   % assign variances
                p.weights   = varargin{1};                   % assign weights
                dimension   = length(varargin{2}{1});        % set dimension
            else
                p.n_members = floor(nargin/3);                 % Set the number of terms
                % in the mixture
                p.means = cell(p.n_members,1);                 % initialization of cell
                % of means
                p.variances = cell(p.n_members,1);             % initialization of cell
                % of variances
                dimension = length(varargin{2});
                for i=1:p.n_members
                    p.weights(i) = varargin{3*i-2};              % Set weight of i-th
                    % mixture member
                    p.means{i} = varargin{3*i-1};                % assign the mean and
                    p.variances{i} = varargin{3*i};              % variance of Gaussian pdf
                    if  dimension ~= length(varargin{3*i-1})     % check whether the
                        error('nft2:gspdf:mean_match_var','Requires means and variances to match in size');
                        % dimension of current
                    end                                          % term comply
                end
            end
        else
            error('nft2:gspdf:incons_arg','Inconsistent arguments');
        end
    end
    p = class(p,'gspdf',general_pdf);
    p = set(p,'dim',dimension);

    %****************************************************************************
    %*** verification ******************************************************** **
    %****************************************************************************
    verify(p);
end

% CHANGELOG
