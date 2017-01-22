function value = get(gspdf,parameter)
% GET -
%
%
% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch parameter
    case 'weights'
        value = gspdf.weights;           % outputs weights of mixture terms
    case 'gpdfs'
        value = cell(gspdf.n_members,1); % initialization of cell of Gaussian pdfs
        for i = 1:gspdf.n_members        % get i-th mixture term (Gaussian pdf)
            value{i} = gpdf(gspdf.means{i},gspdf.variances{i}) % and pass it to output
        end
    case 'means'
        value = gspdf.means;             % outputs means of mixture terms
    case 'variances'
        value = gspdf.variances;         % outputs variances of mixture terms
    otherwise
        value = get(gspdf.general_pdf,parameter);
        %error([parameter, ' is not valid parameter name!']);
end;

