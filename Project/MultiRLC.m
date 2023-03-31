function [Rvals,Lvals,Cvals,Gvals,valsMap] = MultiRLC(ports,poles,res)

    % matlab does not support arrays of matrices;
    % residues matrix will be kept in the form given by vfit3
    % 
    
    
    % calculate number of connections
    % assume matrix symmetrical across diagonal;
    % number of terms for n ports = sum from 1 to n;
    p2p = ports*(ports+1)/2;
    % create new variable for total p2p
    % poles repeated for each port
    p2p_total = p2p*(poles/ports);
    % initialize port to port connections;
    % ex. Y13: node 1 to node 3
    valsMap = strings(1,p2p_total);
    % Rval, Lval, Cval, and Gval of port to port matrix
    Rvals = zeros(1,p2p_total);
    Lvals = zeros(1,p2p_total);
    Cvals = zeros(1,p2p_total);
    Gvals = zeros(1,p2p_total);
    % matrix to match with residues
    TF = zeros(size(res));
    %count complex cases
    compCount = 0;
    % loop over TFs;
    % loop over poles;
    for p = 1:(poles/ports)
        real = true;
        % TFs matrix should be symmetric across diagonal
        for i = 1:p2p
            if (i==1) 
                % initial case (1,n)
                % add 1 for each complex case 
                % (2 sets of residues per complex case)
                n = ports*(p+compCount);
                TF(1,n) = res(1,n);
                if(isreal(res(1,n)) && isreal(poles(p*ports)))
                    % (1/L)/(s+R/L)
                    % c = 1/L, p = -R/L
                    % L = 1/c
                    Lvals(p) = (1/res(1,n));
                    % R = -pL
                    Rvals(p) = (poles(p*ports)/res(1,n));
                    % set zeros
                    Cvals(p) = 0;
                    Gvals(p) = 0;
                    
                    % contribution to (1,1),(n,n),(1,n), and (n,1)
                    TF(1,n) = res(1,n);
                    TF(ports,(n-(ports-1))) = TF(1,n);
                    TF(1,(n-(ports-1))) = -(TF(1,n));
                    TF(ports,n) = -(TF(1,n));
                else
                    % complex case (RLC)
                    real = false;
                    % 2 complex conjugate poles/residues
                    
                end
            end
            % compare TF to res
            % set vals
            % add term to TF

            % loop over remaining terms (p2p-1 iterations) 
            
            
        
        end
        % do last comparison of whole matrix?
            
        if (real==false)
            % increment complex counter
            compCount=compCount+1;
        end
    end
end