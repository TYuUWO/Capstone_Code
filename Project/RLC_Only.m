function [Rvals,Lvals,valsMap] = RLC_Only(ports,TFs)
    % calculate number of connections
    % assume matrix symmetrical across diagonal;
    % number of terms for n ports = sum from 1 to n;
    p2p = ports*(ports+1)/2;
    % initialize port to port connections;
    % ex. Y13: node 1 to node 3
    valsMap = strings(1,p2p);
    for i = 1:p2p
        valsMap(i) = "n"+string(ceil(i/max(size(TFs))))+string(mod(i,max(size(TFs))));
    end
    % 1 Rval, 1 Lval per port to port per matrix
    Rvals = zeros(1,p2p);
    Lvals = zeros(1,p2p);
    Cvals = zeros(1,p2p);
    Gvals = zeros(1,p2p);
    TF2 = zeros(size(TFs));
    % loop over TFs;
    % TFs matrix should be symmetric across diagonal
    for i = 1:p2p
        if (i==1) 
            % initial case (1,n)
            n = size(TFs,2);
            TF2(1,n) = TFs(1,n);
            if(isreal(TFs(1,n)))
               % (1/L)/(s+R/L)
               % c = 1/L, p = -R/L
               Rvals(1) = ();
               Lvals(1) = ();
            else
               % complex case (RLC)
               
            end
        end
        % compare TF2 to TFs
        % set Rval and Lval
        % add term to TF2
        
    end
    % do last comparison of whole matrix?
end