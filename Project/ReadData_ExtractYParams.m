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

    else % neither first not last line in the set
        temp = temp + " " + line;

    end

    inLine = inLine + 1;
end

% allocate array for s parameters
sparams = zeros(size(stringArray) * NUMBER_OF_PORTS / 2);

count = 1; % final count of s params

% get every number in the string array and make them their own s parameters
for i = 1:size(stringArray) * NUMBER_OF_PORTS * NUMBER_OF_PORTS % 4 ports = 16 complex numbers per line

    if(mod(i,2) == 0) % pair every 2 numbers as one complex number
        sparams(count) = double(stringArray(i)) + double(stringArray(i+1)) * 1j;
        count = count + 1;

    end
end

fclose(fileID);

% eventually this will be a function that returns yparams
yparams = s2y(sparams);


