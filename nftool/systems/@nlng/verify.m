function res = verify(p,ferr)
% NLNG/VERIFY verify parameters NLNG
% ferr = 1 >>> error
% ferr = 0 >>> warning
%
% returns 0 for error
% returns 1 for valid data
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% suppose any error
res = 0;

% pw, pv, px0 must inherit from general_pdf class
if not (isa(p.pw,'general_pdf') | isa(p.pv,'general_pdf') | isa(p.px0,'general_pdf')),
    error('nft2:nlng:must_inh_genpdf','Must inherit from ''general_pdf'' class');
    return
end

% verification of Pdf and dimension of random vector
if (p.nw ~= dim(p.pw)),
    error('nft2:nlng:pw_vs_w','Pdf pw doesn''t correspond to dimension of random vector w');
    return
end
if (p.nv ~= dim(p.pv)),
    error('nft2:nlng:pv_vs_v','Pdf pv doesn''t correspond to dimension of random vector v');
    return
end
if (p.nx ~= dim(p.px0)),
    error('nft2:nlng:px0_vs_x','Pdf px0 doesn''t correspond to dimension of state x');
    return
end
if (p.nx ~= p.nw),
    error('nft2:nlng:x_vs_w','State dimension doesn''t correspond to dimension of random vector w');
    return
end

% verify transition equation
tf = p.f;
%if (tf.nf2~=1) | (tf.nf1~=p.nx),
if (tf.mappingDimension~=p.nx),
    error('nft2:nlng:f_not_spec','Transfer funtion is not properly specified');
    return
end

% verify measurement equation
%mf = p.h;
%if mf.nf2~=1,
%    error('nft2:nlng:h_not_spec','Measurement funtion is not properly specified'));
%    return
%end

% OK
res = 1;

% CHANGELOG
