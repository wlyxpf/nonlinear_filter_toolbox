function [pred] = pred_calculation(ngpts,eta,vgrid,inv,konst,p_filt,grmass)

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% exponent = zeros(1,prod(ngpts));
pred = zeros(1,prod(ngpts));

% for j = 1:prod(ngpts)
%   for i = 1:size(eta,2)
%     exponent(j) = (vgrid(:,j) - eta(:,i))'*inv*(vgrid(:,j) - eta(:,i));
%   end %i
%   p_pred(j) = p_filt*exp(-0.5*exponent(j));
% end %j
% 
% pred = grmass*konst*p_pred;


 for j = 1:prod(ngpts)
   for i = 1:size(eta,2)
     exponent = (vgrid(:,j) - eta(:,i))'*inv*(vgrid(:,j) - eta(:,i));
     pred(j) = pred(j) + grmass*p_filt(i)*konst*exp(-0.5*exponent);
   end %i   
 end %j
