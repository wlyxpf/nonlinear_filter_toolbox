function display(p)
% GPDF/DISPLAY Command window display of a gpdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

dim = length(p.mean);
mid = ceil(dim/2);
pvar = p.var;

%fprintf('%s=\n',inputname(1));
mmax = 0;
for l = 1:dim
    mmax = max(mmax,length(sprintf('%g',p.mean(l))));
end

vmax = zeros(1,dim);
for l = 1:dim
    for j = 1:dim
        vmax(l) = max(vmax(l),length(sprintf('%g',pvar(j,l))));
    end
end


for i = 1:dim
    %stredni hodnota
    if (i == mid)
        fprintf('N(|');%place of N=(
    else
        fprintf('  |');
    end
    mcur = length(sprintf('%g',p.mean(i)));
    if (mcur == 0),mcur = 1;,end
    %mezera pred cislem

    for j = 1:(mmax-mcur),fprintf(' ');,end
    %vlastni cislo
    fprintf('%g|',p.mean(i));
    if (i == mid)
        fprintf(',');
    else
        fprintf(' ');
    end
    %variance
    fprintf('|');

    for l = 1:dim
        %delka aktualniho cisla
        vcur = length(sprintf('%g',pvar(l,i)));
        %pocatecni mezery
        for j = 1:(vmax(l)-vcur),fprintf(' ');,end
        %vlastni cislo
        fprintf('%g',pvar(i,l));
        if (l < dim), fprintf(','),end
    end
    fprintf('|');

    if (i == mid)
        fprintf(')');
    end
    fprintf('\n');
end

% CHANGELOG
