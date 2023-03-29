function [Rvals,Lvals,Cvals,Gvals,valsMap] = RLC_Only(ports,pole,res)
    % calculate number of connections
    % assume matrix symmetrical across diagonal;
    % number of terms for n ports = sum from 1 to n;
    p2p = ports*(ports+1)/2;
    % initialize port to port connections;
    % ex. Y13: node 1 to node 3
    valsMap = strings(1,p2p);
    for i = 1:p2p
        valsMap(i) = "n"+string(ceil(i/max(size(res))))+string(mod(i,max(size(res))));
    end
    % 1 Rval, 1 Lval per port to port per matrix
    Rvals = zeros(1,p2p);
    Lvals = zeros(1,p2p);
    Cvals = zeros(1,p2p);
    Gvals = zeros(1,p2p);
    TF = zeros(size(res));
    count = 0;
    real = 1;
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
            else
               % complex case (RLC)
               % 2 complex conjugate poles
               real = 0;
            end
            count = count+1;
        end
        % compare TF2 to TFs
        % set Rval and Lval
        % add term to TF2
        
        % use a flag because of matlab gimmicks
        if(real)
            % calculate m and n
            m = mod((ports-count),ports);
            if(m == 0)
                m=3;
            end
            n = ceil(count/ports);
            % figure out a m n that stops at diagonal
            % compare
            temp = res(m,n) - TF(m,n);
            
            % adjust TF matrix
            TF(m,n) = TF(m,n) + temp;
            TF(n,m) = TF(n,m) + temp;
            % check for edge case
            if(m ~= n)
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
        else
            % complex case (RLC)
            % 2 complex conjugate poles
            disp("test")
        end
        count = count+1;
    end
    % do last comparison of whole matrix?
    %test
    disp(TF==res)
    disp(TF)
end