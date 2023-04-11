function writeNetlist(valsMap, Rvals, Lvals, Cvals, Gvals,D,E,ports)

    fid = fopen( 'outputNetlist.cir', 'wt' ); % file id to open and write to
    fprintf(fid, "%s\n\n", "Output Netlist"); % write title
    % counter to name intermediate nodes
    counter = 1;
    for i = 1:length(valsMap)
        tempStr = valsMap(i);
        nodex = extractBefore(tempStr, '-');
        nodey = 'n' + extractAfter(tempStr, '-');
        
        if(Rvals(i)~=0)
            if(Lvals(i)~=0)
                % complex case; I assume G = 0 if C =0
                if(Cvals(i)~=0)
                    % %s on an integer will map onto an encoded character
                    % convert value to string?
                    fprintf(fid, "R%u %s %s %s \n", i, nodex, ("m"+counter), compose("%.8e",Rvals(i)));
                    fprintf(fid, "L%u %s %s %s \n", i, ("m"+counter), ("m"+(counter+1)), compose("%.8e",Lvals(i)));
                    counter = counter+1;
                    % I assume parallel is just 2 lines with same nodes
                    fprintf(fid, "C%u %s %s %s \n", i, ("m"+counter), nodey, compose("%.8e",Cvals(i)));
                    fprintf(fid, "R%u %s %s %s \n", i, ("m"+counter), nodey, compose("%.8e",Gvals(i)));
                    counter = counter+1;
                else
                    %real case (RL)
                    fprintf(fid, "R%u %s %s %s \n", i, nodex, ("m"+counter), compose("%.8e",Rvals(i)));
                    fprintf(fid, "L%u %s %s %s \n", i, ("m"+counter), nodey, compose("%.8e",Lvals(i)));
                    counter = counter+1;
                end
            else
                % C=0, L=0, R nonzero
                fprintf(fid, "R%u %s %s %s \n", i, nodex, nodey, compose("%.8e",Rvals(i)));
            end
        else if(Lvals(i)~=0)
                % complex (R = 0)
                if(Cvals(i)~=0)
                    fprintf(fid, "L%u %s %s %s \n", i, nodex, ("m"+counter), compose("%.8e",Lvals(i)));
                    fprintf(fid, "C%u %s %s %s \n", i, ("m"+counter), nodey, compose("%.8e",Cvals(i)));
                    fprintf(fid, "R%u %s %s %s \n", i, ("m"+counter), nodey, Gvals(i));
                    counter = counter+1;
                else
                    % L only
                    fprintf(fid, "L%u %s %s %s \n", i, nodex, nodey, compose("%.8e",Lvals(i)));
                end
                % no real, only imaginary;
                % G should never be nonzero if everthing else is 0
            else if(Cvals(i)~=0)
                    fprintf(fid, "C%u %s %s %s \n", i, nodex, nodey, compose("%.8e",Cvals(i)));
                    fprintf(fid, "R%u %s %s %s \n", i, nodex, nodey, compose("%.8e",Gvals(i)));
                end
            end
        end
        
        % Ri from node x to node y, with value from Rvals

        %nodex = nodey;

%         if (nodex == nodey)
%             nodey = '0';
%         else
%             nodey = nodey + 'i';
%         end
        
        %nodey = extractBefore(nodey, 'i') + 'ii';

        %fprintf(fid, "L%u %s %s %f \n", i, nodex, nodey, Lvals(i));
        % Li from node x to node y, with value from Lvals

        %nodex = nodey;
        %nodey = extractBefore(tempStr, 'i');
    end

    %D is resistor in parallel with each node to node connection, on the
    %diagonal
    %D and E are to be looped through as a diagonal matrix
    p2p = ports*(ports+1)/2;
    m = 1;
    if(D ~= 0)
        for i=1:p2p
             if (i==1) 
                % initial case (1,n)
                n = ports;
                fprintf(fid, "R%u %s %s %s \n", length(valsMap)+i, "n1", ("n"+n), compose("%.8e",D(1,n)));
             else
                % calculate m and n
                n = n-1;
                if(n < m)
                    n = ports;
                    m=m+1;
                end
                fprintf(fid, "R%u %s %s %s \n", length(valsMap)+i, ("n"+m), ("n"+n), compose("%.8e",D(m,n)));
             end
        end
    end
    m = 1;
    if(E ~= 0)
        for i=1:p2p
            if (i==1) 
                % initial case (1,n)
                n = ports;
                fprintf(fid, "C%u %s %s %s \n", length(valsMap)+p2p+i, "n1", ("n"+n), compose("%.8e",E(1,n)));
            else
               % calculate m and n
                n = n-1;
                if(n < m)
                    n = ports;
                    m=m+1;
                end
                fprintf(fid, "C%u %s %s %s \n", length(valsMap)+p2p+i, ("n"+m), ("n"+n), compose("%.8e",E(m,n)));
            end
        end
    end
    fprintf(fid, "\n%s\n", ".end");

    fclose(fid);

    open 'outputNetlist.cir'

end


