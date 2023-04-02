clear all

filename = "FEXT_2Away_Hdr_D89_Rcpt_B89_Clamped.s4p";
fileID = fopen(filename); % open the file from which to read data

NUMBER_OF_PORTS = 4;

line = fgetl(fileID);

while (line(1) ~= '#') % find the start of the data
    line = fgetl(fileID);
end

stringArray = " ";
inLine = 1;
outLine = 1; % index of the input and output lines
temp = ""; % current output line being parsed
frequencies = 0;

while ~feof(fileID)
%     for i = 1:NUMBER_OF_PORTS
%         line = line + " " + string(fgetl(fileID));
%     end
    line = string(fgetl(fileID));

    if (mod(inLine , NUMBER_OF_PORTS) == 1) % the first line, containing frequency
        temp = line;

    elseif (mod(inLine , NUMBER_OF_PORTS) == 0)% the last line in the measurement
        temp = temp + " " + line;

        % take and store the frequency
        frequencies(outLine) = extractBefore(temp, " ");
        stringArray(outLine) = extractAfter(temp, " ");

        outLine = outLine + 1;

    else % neither first nor last line in the set
        temp = temp + " " + line;
    end

    inLine = inLine + 1;
end


numsArray = zeros(size(stringArray, 2), 2*NUMBER_OF_PORTS*NUMBER_OF_PORTS);
% allocate array for s parameters
sparams = zeros(NUMBER_OF_PORTS, NUMBER_OF_PORTS, max(size(numsArray)));
% N x N x frequencies

% there's 32 numbers in a line
% 16 complex numbers in a line
% need a NxN array for every line


% get every number in the string array and make them their own s parameters
for i = 1:max(size(stringArray)) % for every line, every string in stringArray

    numsArray(i,:) = str2num(stringArray(i)); % make each number its own element
    count = 1; % final count of s params

    for j = 1:NUMBER_OF_PORTS % for 4 complex numbers (8 numbers total)
        for k = 1:2:NUMBER_OF_PORTS*2 
            sparams(j,round(k/2),i) = numsArray(i,(k+(j-1)*8)) + numsArray(i,((k+1)+(j-1)*8))*1j;
        end
    end
end

fclose(fileID);

% returns yparams
yparams = s2y(sparams);

yReshaped = reshape(yparams, [NUMBER_OF_PORTS*NUMBER_OF_PORTS length(frequencies)]);