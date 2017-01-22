function p = initializeSecondPartialDerivative(p)
%initializeSecondPartialDerivative - initializes the data structure holding
%  the second partial derivative along all quanties defined in the vector
%  mapping
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


nvars = p.nvar;                          % get the number of the variables

if isempty(p.secondDerivative)
    % create symbolic function form the string describing the multivariate
    % vector mapping
    f = sym(p.nffun);

    % prepare symbolic variables from the list of all quantities elements
    parameters = p.parameters;           % get the list of variables
    symvars = sym(zeros(1,nvars));       % prealocate array of symbolic variables

    for i = 1:nvars
        symvars(i) = sym(parameters{i});
    end

    % determine the first differentiate of the function along all the
    % symbolic variables
    J = jacobian(f, symvars);

    % determine Hessian matrix and create its string representation
    cellDimension  = (p.nu+p.nx+p.nxi);  % dimesion of the cell array
    % holding the second partial
    % derivatives
    secondPartialDerivatives = cell(cellDimension,cellDimension);
    %create the cell array

    % determine the MATLAB release number
    release_number = str2num(version('-release'));

    % determine Hessian matrices of each row of multivariate vector mapping
    % and create their string representation
    for i=1:nvars
        %===============================================================
        % create cell of strings describing Hessian matrices containing
        % second partial derivatives of the multivariate vector mappings
        % --------------------------------------------------------------
        for j = 1:nvars
            tmpPartialDerivative = jacobian(J(:,j),symvars(i));
            % --------------------------------------------------------------
            % it is necesary to remove prefixed description and convert
            % commas to semicolons
            % --------------------------------------------------------------
            if ( isempty(release_number) || release_number>13 )
                secondPartialDerivatives{i,j} = strrep(char(tmpPartialDerivative),'matrix','');
            else
                secondPartialDerivatives{i,j} = strrep(char(tmpPartialDerivative),'array','');
            end
            secondPartialDerivatives{i,j} = strrep(secondPartialDerivatives{i,j},'],','];');
            %=============================================================
        end
    end
    p.secondDerivative = secondPartialDerivatives;
end
