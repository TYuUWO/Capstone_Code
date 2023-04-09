function writeNetlist(valsMap, Rvals, Lvals, Cvals, Gvals)

    fid = fopen( 'outputNetlist.cir', 'wt' ); % file id to open and write to
    fprintf(fid, "%s\n\n", "Output Netlist"); % write title

    for i = 1:length(valsMap)
        tempStr = valsMap(i);
        nodex = extractBefore(tempStr, '-');
        nodey = 'n' + extractAfter(tempStr, '-') + 'i';

        fprintf(fid, "R%u %s %s %f \n", i, nodex, nodey, Rvals(i));
        % Ri from node x to node y, with value from Rvals

        nodex = nodey;

%         if (nodex == nodey)
%             nodey = '0';
%         else
%             nodey = nodey + 'i';
%         end
        
        nodey = extractBefore(nodey, 'i') + 'ii';

        fprintf(fid, "L%u %s %s %f \n", i, nodex, nodey, Lvals(i));
        % Li from node x to node y, with value from Lvals

        nodex = nodey;
        nodey = extractBefore(tempStr, 'i');
    end

    %D is resistor in parallel with each node to node connection, on the
    %diagonal
    %D and E are to be looped through as a diagonal matrix

    fprintf(fid, "\n%s\n", ".end");

    fclose(fid);

    open 'outputNetlist.cir'

end


