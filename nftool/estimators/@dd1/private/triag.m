function M = triag(N);

% Householder triangularization, 
% N is rectangular matrix, M is square matrix,
% M is determined so that the equality  M*M' = N*N' holds

% References:
% G.W. Steward (1998): Matrix Algorithms, Vol. I: Basic Decomposition.
% M.S. Grewal, A.P. Andrews (2001): Kalman Filtering: Theory and Practise Using MATLAB.
% M. Noorgard, N.K. Poulsen, O. Ravn (2000): KALMTOOL.
% G.H. Golub, C.F. van Loan (1996): Matrix Computation, 3rd Edition. 

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%initialization
[a,b]=size(N);
dif = b-a;
v = zeros(a,1);
u = zeros(1,b);
M = zeros(a,a);

%Householder triangularization
for i = a:-1:1,
   m(1:dif+i) = N(i,1:dif+i);
   ny = norm(m(1:dif+i));
   if ny == 0,
     m(dif+i) = sqrt(2);
   else
      m(1:dif+i) = m(1:dif+i)/ny;
      if m(dif+i) >= 0,  
        m(dif+i) = m(dif+i) + 1;
        ny = -ny;
      else
        m(dif+i) = m(dif+i) - 1;
      end
      m(1:dif+i) = m(1:dif+i)/sqrt(abs(m(dif+i)));
   end
   v(1:i-1,1) = N(1:i-1,1:dif+i)*m(1,1:dif+i)';
   N(1:i-1,1:dif+i) = N(1:i-1,1:dif+i) - N(1:i-1,1:dif+i)*m(1,1:dif+i)'*m(1,1:dif+i);
   M(1:i-1,i) = N(1:i-1,dif+i);
   M(i,i) = ny;
end