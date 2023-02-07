function [Rvals,Lvals,valsMap] = RL_Only(ports,TFs)
    % calculate number of connections
    p2p = ()ports;
    % initialize port to port connections;
    % Y13 = node 1 to node 3
    valsMap = [];
    % 1 Rval, 1 Lval per port to port
    Rvals = zeros(1,p2p);
    Lvals = zeros(1,p2p);
    TF2 = zeros(size(TFs));
    % loop over TFs;
    % TFs matrix should be symmetric across diagonal
    for i = 1:p2p
        % compare TF2 to TFs
        % set Rval and Lval
        % add term to TF2
    end
end