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
    p2p_total = p2p*(max(size(poles))/ports);
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
    for p = 1:(max(size(poles))/ports)
        % assume real; change flag if complex
        real = true;
        % TFs matrix should be symmetric across diagonal
        for i = 1:p2p
            if (i==1) 
                % initial case (1,n)
                % add 1 for each complex case 
                % (2 sets of residues per complex case)
                n = ports*(p+compCount);
                m = 1;
                TF(1,n) = res(1,n);
                if(isreal(res(1,n)) && isreal(poles(p+compCount)))
                    % (1/L)/(s+R/L)
                    % c = 1/L, p = -R/L
                    % L = 1/c
                    Lvals(i+(p2p*(p-1))) = (1/res(1,n));
                    % R = -pL
                    Rvals(i+(p2p*(p-1))) = (poles(p+compCount)/res(1,n));
                    % set zeros
                    Cvals(p) = 0;
                    Gvals(p) = 0;
                    if(res(1,n) == 0)
                        Lvals(p) = 0;
                        Rvals(p) = 0;
                        Cvals(p) = 0;
                        Gvals(p) = 0;
                    end
                    valsMap(i+(p2p*(p-1))) = "n"+1+(n-(ports*(p+compCount-1)));
                    % contribution to (1,1),(n,n),(1,n), and (n,1)
                    TF(1,n) = res(1,n);
                    TF(ports,(n-(ports-1))) = TF(1,n);
                    TF(1,(n-(ports-1))) = -(TF(1,n));
                    TF(ports,n) = -(TF(1,n));
                else
                    % complex case (RLC)
                    real = false;
                    % 2 complex conjugate poles/residues
                    % complex conjugate residue placed side by side
                    % x, x*, y, y* ...
                    % real(x), imag(x) -> r0 real(res), r1 imag(res),
                    % p0 real(pole), p1 imag(pole)
                    % 2r0s - 2p0r0 - 2r1p1 (num)
                    % s^2 - 2p0s + (p0^2 + p1^2) (den)
                    % 1/L = 2r0 -> L = 1/(2r0)
                    
                end
            else
                % compare TF to res
                % set vals
                % add term to TF

                % loop over remaining terms (p2p-1 iterations) 
                % recalculate n, check m and recalculate if needed
                n = n-1;
                nVirt = n-(ports*(p+compCount-1));
                if(nVirt < m)
                    n = ports*(p+compCount);
                    nVirt = n-(ports*(p+compCount-1));
                    m=m+1;
                end
                
                if(isreal(res(m,n)) && isreal(poles(p+compCount)))
                    % real case
                    % figure out a (m,n) that stops at diagonal
                    % compare
                    temp = res(m,n) - TF(m,n);
                
                    % adjust TF matrix
                    TF(m,n) = TF(m,n) + temp;
                
                    % check for edge case
                    if(m ~= nVirt)
                        %n,m
                        TF(nVirt,(m+ports*(p+compCount-1))) = TF(nVirt,(m+ports*(p+compCount-1))) + temp;
                        %m,m
                        TF(m,(m+ports*(p+compCount-1))) = TF(m,(m+ports*(p+compCount-1))) - temp;
                        %n,n
                        TF(nVirt,n) = TF(nVirt,n) - temp;
                    end
                
                    % (1/L)/(s+R/L)
                    % c = 1/L, p = -R/L
                    % 1/c = L
                    % use temp value for c
                    Lvals(i+(p2p*(p-1))) = (1/temp);
                    % R = -pL
                    Rvals(i+(p2p*(p-1))) = (poles(p+compCount)/temp);
                    Cvals(i+(p2p*(p-1))) = 0;
                    Gvals(i+(p2p*(p-1))) = 0;
                    valsMap(i+(p2p*(p-1))) = "n"+m+nVirt;
                    if(temp == 0 && res(m,n) == 0)
                        Lvals(i+(p2p*(p-1))) = 0;
                        Rvals(i+(p2p*(p-1))) = 0;
                        Cvals(i+(p2p*(p-1))) = 0;
                        Gvals(i+(p2p*(p-1))) = 0;
                    end
                else
                    % complex case
                    disp("test")
                end
            end
        
        end
        % do last comparison of whole matrix?
            
        if (real==false)
            % increment complex counter
            compCount=compCount+1;
        end
        % check if everything is accounted for
        if(p == ((max(size(poles))/ports)-compCount))
            break
        end
    end
    % cut empty elements from arrays
    valsMap = valsMap(1:p2p_total-compCount);
    Rvals = Rvals(1:p2p_total-(compCount*p2p));
    Lvals = Lvals(1:p2p_total-(compCount*p2p));
    Cvals = Cvals(1:p2p_total-(compCount*p2p));
    Gvals = Gvals(1:p2p_total-(compCount*p2p));
    %disp(TF)
    disp(res)
end