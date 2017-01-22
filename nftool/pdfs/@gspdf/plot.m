function plot(p,points)
% GSPDF/PLOT  PLOT() plots gspdf at given points
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

s = length(p.means{1});
if s == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1-DIMENSIONAL %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin == 1
        for i=1:p.n_members
            means(i) = p.means{i};
            vars(i) = p.variances{i};
        end
        [ma,ima]=max(means);
        [mi,imi]=min(means);
        r=abs(ma-mi)+5*max([sqrt(vars(ima)) sqrt(vars(imi))]);
        x=(-1:0.01:1)*r+mi;
    else
        x=points;
    end
    y=evaluate(p,x);
    plot(x,y);
    title('gspdfs');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2-DIMENSIONAL %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif s == 2
    if nargin == 1
        for i=1:p.n_members
            means(:,i) = p.means{i};
        end
        [ma1,ima1]=max(means(1,:));
        [mi1,imi1]=min(means(1,:));
        [ma2,ima2]=max(means(2,:));
        [mi2,imi2]=min(means(2,:));
        r(1) = ma1-mi1+1;
        r(2) = ma2-mi2+1;
        x1 = (-3:0.1:3)*r(1)+mi1;
        x2 = (-3:0.1:3)*r(2)+mi2;
        for i=1:length(x1)
            for j=1:length(x2)
                y(i,j)=evaluate(p,[x1(i) x2(j)]');
            end
        end
    else

    end
    mesh(x1,x2,y);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3 or MORE  DIMENSIONAL %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    error('nft2:gspdf:u_plot_gspdf_hd','Unable to plot gspdf for high dimensions');
end



% CHANGELOG

