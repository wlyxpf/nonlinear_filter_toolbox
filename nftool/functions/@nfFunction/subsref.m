function val = subsref(p,prop)
% SUBSREF nffunction
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('This type of referencing is not implemented!');
    case '.'
        switch prop.subs
            case 'nffun'
                val = p.nffun;
            case 'dimension'
                val = p.mappingDimension;
            case 'parameters'
                val = p.parameters;
            case 'nvar'
                val = p.nvar;
            case 'u'
                if p.nu == 0
                    val = {};
                else
                    val = p.parameters(1:p.nu);
                end                
            case 'nu'
                val = p.nu;
            case 'x'
                val = p.parameters(p.nu+1:p.nu+p.nx);
            case 'nx'
                val = p.nx;
            case 'xi'
                val = p.parameters((p.nu+p.nx+1):(p.nu+p.nx)+p.nxi);
            case 'nxi'
                val = p.nxi;
            otherwise
                error([prop.subs,' is not a valid property!']);
        end;
    case '{}'
        error('This type of referencing is not implemented!');  
end

% CHANGELOG
