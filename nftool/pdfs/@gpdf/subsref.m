function val = subsref(p,prop)
% SUBSREF gpdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
case '()'
  val = evaluate(p,prop.subs{:});
case '.'
  switch prop.subs
  case 'mean'
    val = p.mean;
  case 'var'
    val = p.var;
  otherwise
    val = subsref(p.general_pdf,prop);  
  end  
case '{}'
  error('nft2:gpdf:not_imp','Not implemented!');
end

% CHANGELOG











