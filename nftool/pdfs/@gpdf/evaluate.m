function value = evaluate(p,points)
% GPDF/EVALUATE evaluates general pdf
% V = EVALUATE(P,POINTS) evaluate given gpdf P at POINTS
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

mean = p.mean;             % get the mean value of the pdf
variance = p.var;          % get the variance of the pdf

dimension = get(p,'dim');  % determine dimension of the random variable

%check for matching dimensions
if size(points,1) ~= dimension
    error('nft2:gpdf:nonscalar_match','Requires non-scalar arguments to  match in size.');
end

% evaluate
if dimension==1
    value = exp(-0.5*(points-mean).^2/variance) / sqrt(2*pi*variance);
else
    numberOfPoints = size(points,2); % determine the number of points to evaluate
    invCovariance = inv(variance);
    variableValue = zeros(1,numberOfPoints);

    for i = 1:numberOfPoints
        variableValue(i) = (points(:,i)-mean)'*invCovariance*(points(:,i)-mean);
    end
    value = exp(-0.5*variableValue)/(2*pi)^(dimension/2)/sqrt(det(variance));
end









