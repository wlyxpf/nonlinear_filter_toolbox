function [linearity] = islinear(p,varargin)
% nfLinFunction/islinear - this method tell whether the object represents linear function
%   
% p         ... object of the class nfLinFunction
% varargin  ... the linearity is determined with respect to "variables",
%               however, for linear function is the information about
%               this variable irrelevant. varargin is used only for
%               compatibility reasons with other nfFunction child classes.
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

linearity = 1;  % objects defined by this class are always linear

% CHANGELOG
