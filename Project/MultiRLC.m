function [Rvals,Lvals,Cvals,Gvals,valsMap] = MultiRLC(ports,poles,res)

    % matlab does not support arrays of matrices;
    % residues matrix will be kept in the form given by vfit3
    % 
    
    
    % calculate number of connections
    % assume matrix symmetrical across diagonal;
    % number of terms for n ports = sum from 1 to n;
    p2p = ports*(ports+1)/2;
    % initialize port to port connections;
    % ex. Y13: node 1 to node 3
    valsMap = strings(1,p2p*poles);
    % Rval, Lval, Cval, and Gval of port to port matrix
    Rvals = zeros(1,p2p*poles);
    Lvals = zeros(1,p2p*poles);
    Cvals = zeros(1,p2p*poles);
    Gvals = zeros(1,p2p*poles);
    % matrix to match with residues
    TF = zeros(size(res));
    % loop over TFs;
    % TFs matrix should be symmetric across diagonal
    for i = 1:p2p
        if (i==1) 
            % initial case (1,n)
            n = ports;
            TF(1,n) = res(1,n);
            if(isreal(res(1,n)) && isreal(poles(1)))
               % (1/L)/(s+R/L)
               % c = 1/L, p = -R/L
               % L = 1/c
               Lvals(1) = (1/res(1,n));
               % R = -pL
               Rvals(1) = (poles(1)/res(1,n));
            else
               % complex case (RLC)
               % 2 complex conjugate poles
               
            end
        end
        % compare TF to res
        % set vals
        % add term to TF
        
    end
    % do last comparison of whole matrix?

end