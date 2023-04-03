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
        realNo = true;
        % TFs matrix should be symmetric across diagonal
        for i = 1:p2p
            if (i==1) 
                % initial case (1,n)
                % add 1 for each complex case 
                % (2 sets of residues per complex case)
                % residues in the form r1, r2,... r1, r2,...
                % 1, poles/ports +1, etc for each matrix
                % for rightmost element: #poles * #ports-1 - (p + complex -1)?
                n = (max(size(poles))/ports)*(ports-1) + p+compCount;
                nVirt = ports;
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
                        Lvals(i+(p2p*(p-1))) = 0;
                        Rvals(i+(p2p*(p-1))) = 0;
                        Cvals(i+(p2p*(p-1))) = 0;
                        Gvals(i+(p2p*(p-1))) = 0;
                    end
                    valsMap(i+(p2p*(p-1))) = "n"+1+"-"+(nVirt);
                    % contribution to (1,1),(n,n),(1,n), and (n,1)
                    TF(1,n) = res(1,n);
                    TF(ports,p+compCount) = TF(1,n);
                    TF(1,p+compCount) = -(TF(1,n));
                    TF(ports,n) = -(TF(1,n));
                    
                else
                    % complex case (RLC)
                    realNo = false;
                    % 2 complex conjugate poles/residues
                    % complex conjugate residue placed side by side
                    % x, x*, y, y* ...
                    % real(x), imag(x) -> r0 real(res), r1 imag(res),
                    % p0 real(pole), p1 imag(pole)
                    r0 = real(res(1,n));
                    r1 = imag(res(1,n));
                    
                    p0 = real(poles(p+compCount));
                    p1 = imag(poles(p+compCount));
                    
                    
                    % 2r0s - 2p0r0 - 2r1p1 (num)
                    % s^2 - 2p0s + (p0^2 + p1^2) (den)
                    % 1/L = 2r0 -> L = 1/(2r0)
                    Lvals(i+(p2p*(p-1))) = 1/(2*r0);
                    % R = (p0-(r1*p1/r0))/2r0
                    Rvals(i+(p2p*(p-1))) = (p0-(r1*p1/r0))/(2*r0);
                    % C = 2(r0^3)/((p0^2+p1^2)*(r0^2)-(p0^2)+((r1^2)*(p1^2)))
                    Cvals(i+(p2p*(p-1))) = (2*(r0^3))/(((p0^2)+(p1^2))*(r0^2)-(p0^2)+((r1^2)*(p1^2)));
                    % ((p0^2+p1^2)*(r0^2) - (p0^2) + ((r1^2)*(p1^2)))/
                    % (2(r0^3)*(p0+(r1*p1/r0)))
                    Gvals(i+(p2p*(p-1))) = ((((p0^2)+(p1^2))*(r0^2)) - (p0^2) + ((r1^2)*(p1^2)))/((2*(r0^3)*(p0+(r1*p1/r0))));
                    
                    % contribution to (1,1),(n,n),(1,n), and (n,1)
                    TF(1,n) = res(1,n);
                    TF(ports,p+compCount) = TF(1,n);
                    TF(1,p+compCount) = -(TF(1,n));
                    TF(ports,n) = -(TF(1,n));
                    % contribution to (1,1+1),(n,n+1),(1,n+1), and (n,1+1)
                    TF(1,n+1) = res(1,n+1);
                    TF(ports,p+compCount+1) = TF(1,n+1);
                    TF(1,p+compCount+1) = -(TF(1,n+1));
                    TF(ports,n+1) = -(TF(1,n+1));
                    
                    if(res(1,n) == 0)
                        Lvals(i+(p2p*(p-1))) = 0;
                        Rvals(i+(p2p*(p-1))) = 0;
                        Cvals(i+(p2p*(p-1))) = 0;
                        Gvals(i+(p2p*(p-1))) = 0;
                    end
                    valsMap(i+(p2p*(p-1))) = "n"+1+"-"+nVirt;
                end
            else
                % compare TF to res
                % set vals
                % add term to TF

                % loop over remaining terms (p2p-1 iterations) 
                % recalculate n, check m and recalculate if needed
                % spaced a set of poles apart
                n = n-(max(size(poles))/ports);
                nVirt = nVirt-1;
                if(nVirt < m)
                    n = (max(size(poles))/ports)*(ports-1) + p+compCount;
                    nVirt = ports;
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
                        TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount)) = TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount)) + temp;
                        %m,m
                        TF(m,((max(size(poles))/ports)*(m-1)+p+compCount)) = TF(m,((max(size(poles))/ports)*(m-1)+p+compCount)) - temp;
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
                    valsMap(i+(p2p*(p-1))) = "n"+m+"-"+nVirt;
                    if(temp == 0)
                        Lvals(i+(p2p*(p-1))) = 0;
                        Rvals(i+(p2p*(p-1))) = 0;
                        Cvals(i+(p2p*(p-1))) = 0;
                        Gvals(i+(p2p*(p-1))) = 0;
                    end
                else
                    % complex case
                    % figure out a (m,n) that stops at diagonal
                    % compare set of complex residues?
                    % real(x), imag(x) -> r0 real(res), r1 imag(res),
                    % p0 real(pole), p1 imag(pole)
                    r0 = real(res(1,n));
                    r1 = imag(res(1,n));
                    
                    p0 = real(poles(p+compCount));
                    p1 = imag(poles(p+compCount));
                    
                    r0c = real(TF(1,n));
                    r1c = imag(TF(1,n));
                    
                    % compare
                    %-- potential err
                    temp0 = 2*r0 - 2*r0c; % diff0
                    temp1 = 2*p0*r0c+2*r1c*p1-(2*p0*r0)-(2*r1*p1); % diff1
                    add1 = (temp1/(2*p1))+(p0*r0/p1)-(p0*r0c/p1)-2*r1c;
                        
                    % adjust TF matrix
                    %-- potential err
                    TF(m,n) = TF(m,n) + (temp0/2)+(add1);
                    TF(m,n+1) = TF(m,n+1) + (temp0/2)-(add1);
                    
                    % check for edge case
                    if(m ~= nVirt) %-- potential err
                        %n,m
                        TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount)) = TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount)) + (temp0/2)+(add1);
                        %n,m+1
                        TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount+1)) = TF(nVirt,((max(size(poles))/ports)*(m-1)+p+compCount+1)) + (temp0/2)-(add1);
                        %m,m
                        TF(m,((max(size(poles))/ports)*(m-1)+p+compCount)) = TF(m,((max(size(poles))/ports)*(m-1)+p+compCount)) - ((temp0/2)+(add1));
                        %m,m+1
                        TF(m,((max(size(poles))/ports)*(m-1)+p+compCount+1)) = TF(m,((max(size(poles))/ports)*(m-1)+p+compCount+1)) - ((temp0/2)-(add1));
                        %n,n
                        TF(nVirt,n) = TF(nVirt,n) - ((temp0/2)+(add1));
                        %n,n+1
                        TF(nVirt,n+1) = TF(nVirt,n+1) - ((temp0/2)-(add1));
                    end
                    
                    % 1/L = diff0 -> L = 1/diff0
                    Lvals(i+(p2p*(p-1))) = 1/temp0;
                    % 
                    Rvals(i+(p2p*(p-1))) = ((p0^2)+(p1^2)/temp1)-1;
                    %
                    Gvals(i+(p2p*(p-1))) =
                    %
                    Cvals(i+(p2p*(p-1))) = 
                    
                    
                    
                    if(temp0 == 0 && temp1 == 0)
                        Lvals(i+(p2p*(p-1))) = 0;
                        Rvals(i+(p2p*(p-1))) = 0;
                        Cvals(i+(p2p*(p-1))) = 0;
                        Gvals(i+(p2p*(p-1))) = 0;
                    end
                    valsMap(i+(p2p*(p-1))) = "n"+m+"-"+nVirt;
                    
                end
            end
        
        end
        % do last comparison of whole matrix?
            
        if (realNo==false)
            % increment complex counter
            compCount=compCount+1;
        end
        
        % check if everything is accounted for
        if(p == ((max(size(poles))/ports)-compCount))
            break
        end
    end
    % cut empty elements from arrays
    valsMap = valsMap(1:p2p_total-(compCount*p2p));
    Rvals = Rvals(1:p2p_total-(compCount*p2p));
    Lvals = Lvals(1:p2p_total-(compCount*p2p));
    Cvals = Cvals(1:p2p_total-(compCount*p2p));
    Gvals = Gvals(1:p2p_total-(compCount*p2p));
    %disp(TF)
    %disp(res)
    %disp(TF==res)
end