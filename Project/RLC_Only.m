function [Rvals,Lvals,Cvals,Gvals,valsMap] = RLC_Only(ports,pole,res)
    % calculate number of connections
    % assume matrix symmetrical across diagonal;
    % number of terms for n ports = sum from 1 to n;
    p2p = ports*(ports+1)/2;
    % initialize port to port connections;
    % ex. Y13: node 1 to node 3
    valsMap = strings(1,p2p);
    
    % 1 Rval, 1 Lval per port to port per matrix
    Rvals = zeros(1,p2p);
    Lvals = zeros(1,p2p);
    Cvals = zeros(1,p2p);
    Gvals = zeros(1,p2p);
    TF = zeros(size(res));
    %count = 0;
    real = 1;
    m = 1;
    % loop over TFs;
    % TFs matrix should be symmetric across diagonal
    for i = 1:p2p
        if (i==1) 
            % initial case (1,n)
            n = ports;
            % matlab hates doubles and all int classes
            
            TF(1,n) = res(1,n);
            TF(n,1) = TF(1,n);
            TF(1,1) = -(TF(1,n));
            TF(n,n) = -(TF(1,n));
            % may be 2 poles for complex conjugate case
            % assume only real residues have real poles
            
            if(isreal(res(1,n)))
               % (1/L)/(s+R/L)
               % c = 1/L, p = -R/L
               Lvals(1) = (1/res(1,n));
               % R = -pL
               Rvals(1) = (-(pole(1)/res(1,n)));
               if(res(1,n) == 0)
                   Lvals(1) = 0;
                   Rvals(1) = 0;
                   Cvals(i) = 0;
                   Gvals(i) = 0;
               end
               valsMap(i) = "n"+1+n;
            else
               % complex case (RLC)
               % 2 complex conjugate poles
               real = 0;
            end
            %count = count+1;
        else
        % compare TF2 to TFs
        % set Rval and Lval
        % add term to TF2
        
        % use a flag because of matlab gimmicks
        if(real)
            % calculate m and n
            n = n-1;
            if(n < m)
                n = ports;
                m=m+1;
            end
            
            % figure out a (m,n) that stops at diagonal
            % compare
            temp = res(m,n) - TF(m,n);
            
            % adjust TF matrix
            TF(m,n) = TF(m,n) + temp;
            
            % check for edge case
            if(m ~= n)
                TF(n,m) = TF(n,m) + temp;
                TF(m,m) = TF(m,m) - temp;
                TF(n,n) = TF(n,n) - temp;
            end
            
            % (1/L)/(s+R/L)
            % c = 1/L, p = -R/L
            % 1/c = L
            % use temp value for c
            Lvals(i) = (1/temp);
            % R = -pL
            Rvals(i) = (pole(1)/temp);
            Cvals(i) = 0;
            Gvals(i) = 0;
            if(temp == 0 && res(m,n) == 0)
                Lvals(i) = 0;
                Rvals(i) = 0;
                Cvals(i) = 0;
                Gvals(i) = 0;
            end
            valsMap(i) = "n"+m+n;
        else
            % complex case (RLC)
            % 2 complex conjugate poles
            disp("program shouldn't reach here")
        end
        %count = count+1;
        end
    end
    % do last comparison of whole matrix?
    %test
    disp(TF==res)
    disp(TF)
end