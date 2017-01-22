function [q]=rndmul(obj,P,N);

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

K=length(P);
%normalizace

P = P/sum(P);

q = zeros(1,N);
for j=1:N
    i=1;
    s=P(1);
    rr=rand;
    while(rr>s)
        i=i+1;
        if i>K
            disp('error')
            keyboard
        end

        s=s+P(i);
    end
    q(j)=i;
end
