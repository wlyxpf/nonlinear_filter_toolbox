function [z,x,p] = simulate(p,varargin)
% nlng/simulate Simulates the system trajectory
%
% [z,x,p] = simulate(p) Simulates one time step of the
%               autononous system trajectory. The state and measurement
%               noises are automaticaly generated as samples from
%               appropriate probability density function.
%         p ... object of one of the system classes
%               (i.e. lga,lnga,nlga,nlnga,nlng)
%         z ... simulated system measurement
%         x ... simulated system state
%
% [z,x,p] = simulate(p,u) Simulates trajectory of system
%               specified by object p with input u. The dimension of
%               u determines number of simulated time steps.The state and
%               measurement noises are automaticaly generated as samples
%               from appropriate probability density function.
%
% [z,x,p] = simulate(p,'quantityName',quantity,...)
%               Simulates trajectory of system specified by object p.
%
%               up to three pairs 'quantityName',quantity are used to
%               specify all the input quantities (i.e. control input, state
%               and measurement noise). Valid 'quantityName' has one of
%               the following value: 'input', 'state noise',
%               'measurement noise'. The quantity parameter then holds
%               the values. If either of the noises is not provided it will
%               be genereted as samples from appropriate probability
%               density function.
%
%               The dimension of specified quanties has to be the same
%               because it determines number of simulated time steps
%               Example:
%                 [z,x,p] = simulate(p,'input',u,'measurement noise',v)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


%% Parse the input data
%
switch nargin
    case 1
        if p.nu ~= 0
            error('nft2:lnga:missingInput',...
                'The system has defined input it should be provided for simulation. ');
        else
            numberOfSteps = 1; % initialize the number of simulated time steps
            % it corresponds to case where there is no input
            data = struct('w',sample(p.pw),'v',sample(p.pv));
        end
    case 2
        if p.nu == 0
            warning('nft2:lnga:u4system_no_input',...
                'The input u is provided even though the system has no input defined!')
        end
        data.('u') = varargin{1};       % store the input in data stucture
        numberOfSteps = size(data.u,2); % number of steps is given by the size of input u
    case {3,5,7}
        % prepare auxiliary structures
        quantityDescriptions = {'input' 'state noise' 'measurement noise'};
        quantityName = {'u' 'w' 'v'};
        quantitiesDimensions = [p.nu p.nw p.nv];

        % analyze the input parameters and locate provided quantities
        providedQuantities = varargin(1:2:nargin-2);
        providedQuantitiesValue = varargin(2:2:nargin-1);
        [areQuantitiesListed,quantitiesIndex] = ismember(providedQuantities,quantityDescriptions);

        % check the provided quantities
        for quantity = 1:sum(areQuantitiesListed)
            if quantitiesDimensions(quantitiesIndex(quantity)) ~= 0
                if ~exist('numberOfSteps','var')
                    % set the number of time steps to simulate
                    numberOfSteps = size(providedQuantitiesValue{quantity},2);
                    % store the processed quantity data to data structure _data_
                    data.(quantityName{quantitiesIndex(quantity)})=providedQuantitiesValue{quantity};
                else
                    if numberOfSteps ~= size(providedQuantitiesValue{quantity},2);
                        error('nft2:nlng:numberStepsNotMatch',...
                            'Length of the arguments doesn''t match!');
                    end
                    % store the processed quantity data to data structure _data_
                    data.(quantityName{quantitiesIndex(quantity)})=providedQuantitiesValue{quantity};
                end
            else
                switch quantityDescriptions{quantitiesIndex(quantity)}
                    case 'input'
                        warning('nft2:nlng:u4system_no_input',...
                            'The input u is provided even though the system has no input defined!');
                    case 'state noise'
                        warning('nft2:nlng:noise4system_no_state_noise',...
                            'The state noise is provided even though the system has no state noise defined!');
                    case 'measurement noise'
                        warning('nft2:nlng:noise4system_no_measurement_noise',...
                            'The measurement noise is provided even though the system has no measurement noise defined!');
                end
            end
        end

        % check if varargin contained nonsupported quiantities
        if sum(areQuantitiesListed) ~= length(providedQuantities)
            warning('nft2:lnga:unknownQuiantities',...
                'Unknown quiantities occured in input agruments');
        end
    otherwise
        error('nft2:lnga:wn_ia','Wrong number of input arguments');
end

%% Test for missing data structure or control input
if ~exist('data','var')              % this should not happen!
    if ~exist('numberOfSteps','var')
        numberOfSteps=1;
    end
    data = struct('w',sampleset(p.pw,numberOfSteps),'v',sampleset(p.pv,numberOfSteps));
end

if ~isfield(data,'u') && (p.nu ~= 0) % control input is expected but not provided
    error('nft2:lnga:missing_input','Control input data are missing!');
end

%% Generate possibly missing samples of noises
if ~isfield(data,'w')        % in case the state noise was not given
    pw = get(p,'pw');        % as input agrument of simulation method
    data.('w') = sampleset(pw,numberOfSteps);     % generate it
end
if ~isfield(data,'v')        % in case the measurement noise was not given
    pv = get(p,'pv');        % as input agrument of simulation method
    data.('v') = sampleset(pv,numberOfSteps);     % generate it
end

%% Procced with simulation of the system trajectory
%
%==========================================================================
% Get system parameters
F = p.F;
G = p.G;
H = p.H;

gamma = get(p,'gamma');
delta = get(p,'delta');
%==========================================================================
% Declare variables holding the trajectory
xs = zeros(p.nx,numberOfSteps+1);
zs = zeros(size(H,1),numberOfSteps+1);
%==========================================================================

%starting with current state
xs(:,1) = get(p,'currentState');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do all steps
for k = 1 : numberOfSteps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if p.t > 0 %in case of t = 0, the state is already given
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % state evaluation
        if p.nu > 0
            xs(:,k+1) = F * xs(:,k) + G * data.u(:,k) + gamma * data.w(:,k);
        else
            xs(:,k+1) = F * xs(:,k) + gamma * data.w(:,k);
        end
        % set the current state
        p = set(p,'currentState',xs(:,k+1));

        % measurement evaluation
        zs(:,k+1) = H * xs(:,k+1) + delta * data.v(:,k);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else %the first step - return initial state and the measurement
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xs(:,k+1) = get(p,'currentState');
        % measurement evaluation
        zs(:,k+1) = H * xs(:,k+1) + delta * data.v(:,k);
    end
    %time step
    p.t = p.t + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Return the similated trajectory
x = xs(:,2:end);
z = zs(:,2:end);

% CHANGELOG
