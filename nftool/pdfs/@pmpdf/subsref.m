function val = subsref(p,prop)
% SUBSREF gpdf
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop(1).type

    case '.'
        switch prop(1).subs
            case 'mass'     % point masses for axis grids (distances of points)
                if length(prop) == 1
                    val = p.mass;
                elseif strcmp(prop(2).type,'()')
                    subs = cell2mat(prop(2).subs);
                    if any(subs<=0 | subs>get(p,'dim'))
                        error('nft2:pmpdf:ind_oor','Index out of range');
                    else
                        val = p.mass(subs);
                    end
                end
            case 'grmass'   % volume mass of the grid
                val = prod(p.mass);
            case 'ngpts'    % number of individual axis grid points
                if length(prop) == 1
                    val = p.ngpts;
                elseif strcmp(prop(2).type,'()')
                    subs = cell2mat(prop(2).subs);
                    if any(subs<=0 | subs>get(p,'dim'))
                        error('nft2:pmpdf:ind_oor','Index out of range');
                    else
                        val = p.ngpts(subs);
                    end
                end
            case 'grngpts'  % total number of axis grid points
                val = prod(p.ngpts);
            case 'values'  % pdf values
                val = p.values;
            case 'axisgrids'  % axis grids
                axgrids = axisgrids(p);
                if length(prop) == 1
                    val = axgrids;
                elseif strcmp(prop(2).type,'{}')
                    subs = cell2mat(prop(2).subs);
                    if any(subs<=0 | subs>get(p,'dim'))
                        error('nft2:pmpdf:ind_oor','Index out of range');
                    else
                        val = axgrids(subs);
                    end
                end
            case 'T'         % floating grid transformation matrix
                val = p.floatgrid.T;
            case 'center'    % floating grid center
                val = p.floatgrid.center;
            case 'gridpts'   % grid points ("vector" grid structure)
                val = gridpts(p);
            case 'mean'      % mean value
                val = mean(p);
            case 'var'       % variance/covariance matrix
                val = var(p);
            otherwise
                val = subsref(p.general_pdf,prop);
        end

    case '{}'
        axgrid = axisgrid(p,cell2mat(prop(1).subs));
        if length(prop) == 1
            val = axgrid;
        elseif strcmp(prop(2).type,'()')
            subs = cell2mat(prop(2).subs);
            if any( subs<=0 | subs>length(axgrid) )
                error('nft2:pmpdf:ind_oor','Index out of range');
            else
                val = axgrid(subs);
            end
        end

    case '()'
        axgrids = axisgrids(p);
        subs = cell2mat(prop(1).subs);
        if any( subs<=0 | subs>get(p,'dim') )
            error('nft2:pmpdf:ind_oor','Index out of range');
        else
            val = axgrids(subs);
        end

end

% CHANGELOG

