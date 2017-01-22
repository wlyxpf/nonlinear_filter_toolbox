function meshstruct = vec2mesh (vecstruct,npts)
% VEC2MESH transforms grid points from vector to mesh.
%
% MESHSTRUCT = VEC2MESH(VECSTRUCT,NPTS)
%   transforms the vector variable VECSTRUCT to the mesh structure
%   MESHSTRUCT based on the values of NPTS (numbers of points). The
%   MESHSRTUCT variable can be used in MESH fuction, for instance.
%   VEC2MESH works for 2-dim systems only (NPTS must be a vector of
%   dimension 2).
%
% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if length(npts)~=2
    error('The function works for 2-dim systems only.')
end

ind = 0;
for j = 1:npts(1)
    for i = 1:npts(2)
        ind = ind + 1;
        meshstruct(i,j) = vecstruct(ind);
    end  
end