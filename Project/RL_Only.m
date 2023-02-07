function [] = RL_Only(ports,TFs)
    % calculate number of connections
    p2p = ()ports;
    % initialize port to port connections;
    % 1 Rval, 1 Lval per port to port
    Rvals = zeros(1,p2p);
    Lvals = zeros(1,p2p);
    TF2 = TFs;
    % loop over TFs;
    for i = 1:p2p
        % compare TF2 to TFs
        % set Rval and Lval
        % add term to TF2
    end
end