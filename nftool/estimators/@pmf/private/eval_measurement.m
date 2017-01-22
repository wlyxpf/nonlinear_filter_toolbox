function meas_det = eval_measurement(system,vgrid)
% EVAL_MEASUREMENT pmf method
%
% Metoda vyhodnocuje vystupni rovnici z(k)=h(k)+E{v(k)}
% h(k)    - deterministicka slozka mereni
% E(v(k)) - stredni hodnota sumu

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

f = system.h;                  % vystupni rovnice systemu
vars = system.x;               % stavove promenne

for i = 1:size(system.x,2)     % pro vsechny stavove promenne
    command = [strcat(vars(i),'=vgrid(',int2str(i),',:);')]; % kazde slozce stavu priradime body site
    eval(command{1});            % ziskame lokalni x1,x2,...,x_n
end

vars = system.v;               % promenne pro vystupni sum
v = mean(system.pv);           % stredni hodnata sumu

for i = 1:size(system.v,2)     % pro vsechny promenne sumu
    command = [strcat(vars(i),'=v(',int2str(i),');')]; % kazde slozce sumu priradime prislusnou stredni hodnotu
    eval(command{1});            % ziskame v=E(v) ve slozkach v1,v2,...,v_m
end

meas_det = eval(f.nffun);      % vyhodnoceni vystupni rovnice v bodech site


