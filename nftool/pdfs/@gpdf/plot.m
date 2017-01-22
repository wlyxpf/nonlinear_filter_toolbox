function plot(p,points,color)
% GPDF/PLOT  PLOT() plots gpdf at given points
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check parameters if they are point and/or colors %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nopoints = 0;
if nargin > 1
    if (isstr(points))
        nopoints = 1;
        color = points;
    else
        if nargin == 2
            color = 'b';
        end
    end
else
    color = 'b';
    nopoints = 1;
end


switch p.general_pdf.dim         % get dimension of random variable
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % one-dimensional variable
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % plot at given points
        if nopoints
            % if no points donn't exist --> default points
            r = sqrt(p.var)*5;
            x = (-1:0.01:1)*r +p.mean;
        else
            x = points;
        end

        y = evaluate(p,x);            % evaluate at points
        plot(x,y,color);                    % plot
        title(sprintf('GPDF, mean=%u , var=%u',p.mean,p.var));
        grid on;

    case 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % two-dimensional variable
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plot at given points
        if nopoints
            % if no points donn't exist --> default points
            r = [5*p.var(1,1) 5*p.var(2,2)];
            x1 = (-1:0.05:1)*r(1)+p.mean(1);
            x2 = (-1:0.05:1)*r(2)+p.mean(2);
        else
            x1=points(1,:);
            x2=points(2,:);
        end

        % evaluate at points
        for i=1:length(x1)
            for j=1:length(x2)
                y(i,j)=evaluate(p,[x1(i); x2(j)]);
            end
        end

        if (size(y,1)==1) && (size(y,2)==1)
            error('nft2:gpdf:mesh_point','Mesh cannot plot only 1 point');
        else
            mesh(x1,x2,y);                % plot
        end

    otherwise
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % three or more dimensional variable
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        error('nft2:gpdf:u_plot_gpdf_hd','Unable to plot gpdf for high dimensions');
end

% CHANGELOG
