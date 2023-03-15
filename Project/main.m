%
% main edit 3

% extract A B C D E from SER
A = SER.A;
B = SER.B;
C = SER.C;
D = SER.D;
E = SER.E;

% A are poles - refer to notes
% C are residues
% D constant



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


