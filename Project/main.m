%
% main edit 3

% extract A B C D E from SER
A = SER.A;
B = SER.B;
C = SER.C;
D = SER.D;
E = SER.E;

% A are poles - refer to notes
% set vector fitting function to place complex in diagonal
% complex conjugates follow
% C are residues
% D constant (resistor in parallel?)

% opts.cmplx_ss=1; use this in vector fitting for simplifying inputs;
% creates diagonal of complex poles instead of off diagonal imaginary;
% isreal() will work even if imaginary part is 0.000000i
% could there be an issue if imaginary part is really small?
% e.g. 0.000000001i

% prompt user for number of ports in case it isn't included in data
ports = input("Number of ports: ");

% extract pole data
% poles are repeated for each port
poles = zeros(1,max(size(A)));

for i = 1:max(size(poles))
    % new pole appears at i + # of poles;
    % each multiple of # of poles will cover all poles
    index = i;
    poles(i) = A(index,index);
end

% pass residues in as is


% if there's only 1 pole (repeated for each port)
if((max(size(poles))==ports))
    [Rvals,Lvals,Cvals,Gvals,valsMap] = RLC_Only(ports,poles,C);
% otherwise use MultiRLC
else
    [Rvals,Lvals,Cvals,Gvals,valsMap] = MultiRLC(ports,poles,C);
end
    
% use for testing (validation) ONLY
% use Y = [C((sI-A)^-1)B+D+sE]
% can perform operations on tf struct
% maybe create tf struct in place of sI and sE?
%s = tf([1 0],1);

% A should be square matrix
%Isize = size(A);
% identity matrix the size of A
%I = eye(max(Isize));
%implement equation
%Y = (C*(inv((s*I)-A)))* B + D + (s*E);


