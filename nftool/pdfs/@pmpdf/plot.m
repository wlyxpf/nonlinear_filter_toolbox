function plot(p)
% PMPDF/PLOT  PLOT() plots pmpdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

s = length(p.ngpts);
if s == 1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1-DIMENSIONAL %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure
    
    X = get(p,'T') * axisgrid(p,1) + get(p,'center');
    plot(X,p.values)
    grid on
    title('pmpdf')
    xlabel('x')
    ylabel('pdf')
    
elseif s == 2
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2-DIMENSIONAL %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    az=-13;
    el=40;
    figure
    
    Xrot = [];
    Yrot = [];
    axgrids = get(p,'axisgrids');
    [X Y] = meshgrid(axgrids{1},axgrids{2});
    Z = vec2mesh(p.values,p.ngpts);
    % floating grid parameters
    T = get(p,'T');
    m = get(p,'center');
    
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            point = T*[X(i,j);Y(i,j)] + m;
            Xrot(i,j) = point(1);
            Yrot(i,j) = point(2);
        end
    end
    mesh(Xrot,Yrot,Z)
    %view(3)
    view(az,el)
    grid on
    title('pmpdf')
    xlabel('x_1')
    ylabel('x_2')
    zlabel('pdf')

else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3 or MORE  DIMENSIONAL %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error('nft2:gspdf:u_plot_gspdf_hd','Unable to plot pmpdf for dimensions higher than 2');
    
end



% CHANGELOG

