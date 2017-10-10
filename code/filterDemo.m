function [ outFreq ] = filterDemo( inputSignal, key )

close all; %Gets rid of other graphs

signal = inputSignal; %Rename signal for testing
xmags = abs(fft(signal)); %get absolute value, or magnitude (Voltage^2), fft(signal)

[col, row] = size(xmags); %col is the long vector
maxMag = max(xmags); %Gets the highest magnitude
maxF = find(xmags == maxMag); %frequency of max magnitude

%TESTING---------------------------------------------------------
%maxF
%TESTING---------------------------------------------------------
%If a freq isn't big enough, it will get the axe
axe1=mean(xmags(1:maxF)*2);
axe2=maxMag/16;
axe3=max(xmags(1:maxF));
%This will choose whichever axe is lower
if(axe1<axe2)
    %fprintf('Choose AXE 1\n')
    axeMag = axe1;
elseif(axe2<axe3)
    %fprintf('Choose AXE 2\n')
    axeMag = axe2;
else
    %fprintf('Choose AXE 3\n')
    axeMag = axe3;
end


GetTwoFactors; %Gives me 1/2^1->1/2^8
freqFactors = twoFactor.*(maxF(1)); %Gives me possible lower harmonies
realFreqFactors = freqFactors(find(freqFactors > 27)); %Gets rid of bad ones

%These are all needed for the For-Loop's calculations
%Essencially gets the octae of highest mag's frequency
[rowRF, colRF] = size(realFreqFactors);
rSignal = zeros(size(signal));
HH = zeros(col/2, row);

%Design a Butterworth Filter for the highest mag's frequency/2
%this will tell me if I am catching 3rd or higher harmonizations
%of a key's frequency.
testWindow = [2*(realFreqFactors(2)-2)/col, 2*(realFreqFactors(2)+2)/col];
[b, a] = butter(3, testWindow , 'bandpass'); %Filter Design
y = filter(b, a, signal); %filters original signal for only the octave
    
%Get highest magnitude of filtered signal FFT for comparisons
yMaxMag = max(abs(fft(y)));

%TESTING--------------------------------------------------------
%{
maxMag
yMaxMag
maxTestF = find(abs(fft(y)) == yMaxMag)
%}
%TESTING--------------------------------------------------------
    
if(yMaxMag<axeMag) %it will get axed if its smaller, and replaced
        %Handles if Harmony is not in an octave...
        %fprintf('1st Axed, Harmony is not in octave...\n')
        for k = [3,5,6,7,9]
            %so here I will not use filters according to the Pythagorean
            %scale, but instead, one of numbers not powers of 2.
            workingFq = (realFreqFactors(1)/k);
            window = [2*(workingFq-2)/col, 2*(workingFq+2)/col];
            [b, a] = butter(3, window , 'bandpass'); %Filter Design

            H = freqz(b,a,floor(col/2)); %Frequency response
     
            y = filter(b, a, signal); %filters original signal for only the octave
            
            %test additional case where highest mag might actually be right
            %one to begin with
            yMaxMag2 = max(abs(fft(y)));
            if(yMaxMag2<axeMag && k==3)
                %fprintf('2nd Axed, Highest Mag is true key\n')
                window = [2*(realFreqFactors(1)-2)/col, 2*(realFreqFactors(1)+2)/col];
                [b, a] = butter(3, window , 'bandpass'); %Filter Design

                H = freqz(b,a,floor(col/2)); %Frequency response
                %Adds up frequency responses to display all at once
                HH = HH + abs(H);
                y = filter(b, a, signal); %filters original signal for only the octave
                rSignal = rSignal+y; %Adds them up for a signal with all octaves
            else
                %Adds up frequency responses to display all at once
                HH = HH + abs(H);
                rSignal = rSignal+y; %Adds them up for a signal with all octaves
            end
        end
else
        %Designs Bandpass Butterworth Filters for every octave at or below the 
        %highest recorded magnitude.
        %fprintf('Harmony is in octave\n');
        for j = 2:colRF
            %Window for the bandpass, its each predicted octave's (j) freqs +/-1Hz
            window = [2*(realFreqFactors(j)-2)/col, 2*(realFreqFactors(j)+2)/col];
            [b, a] = butter(3, window , 'bandpass'); %Filter Design

            H = freqz(b,a,floor(col/2)); %Frequency response
            %Adds up frequency responses to display all at once
            HH = HH + abs(H);
            y = filter(b, a, signal); %filters original signal for only the octave
            rSignal = rSignal+y; %Adds them up for a signal with all octaves
        end
end

fSignal = abs(fft(rSignal)); %fft the filtered signal
hSignal = fSignal(1:col/2); %we only need half of it

%just like earlier, we get the highest mag of the
%filtered signal in freq domain
maxMagH = max(hSignal); 
maxFH = find(hSignal >= maxMagH); %and then the freq of that high mag

%TESTING---------------------------------------------------------
%

keyNames = {'C','C#','D','D#','D','F','F#','G','G#','A','A#','B','C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
[colK, rowK] = size(keyNames);
for i=1:rowK/2
   keyNames(1, (i)) = strcat(keyNames(1, (i)), '3');
end
for i=((rowK/2)+1):rowK
   keyNames(1, (i)) = strcat(keyNames(1, (i)), '4');
end



%Plot filtered signal FFT--------------------------------------------------
figure(3);
plot([0:1/((col/2)-1):1], fSignal(1:col/2));
xticks(0:200/4000:1);
xticklabels(0:200:4000);
title('Filtered Signal FFT ' + string(keyNames(1, key)));

%Plotting to check---------------------------------------------------------
figure(2);
plot([0:1/((col/2)-1):1], xmags(1:col/2).*(1/maxMag), 'b');
hold on;
plot([0:1/((col/2)-1):1], (HH), 'r');
hold off;
title('Original Signal FFT with Frequency Responses ' + string(keyNames(1, key)));
xlabel('Frequency in Hz');
xticks(0:200/((col/2)-1):1);
xticklabels(0:200:4000);
ylabel('Magnitude');

%Plot original signal FFT--------------------------------------------------
figure(1);
plot([0:1/((col/2)-1):1], xmags(1:col/2), 'b');
title('Original Signal FFT ' + string(keyNames(1, key)));
xlabel('Frequency in Hz');
xticks(0:200/((col/2)-1):1);
xticklabels(0:200:4000);
ylabel('Magnitude');

%
%TESTING---------------------------------------------------------
outFreq = (maxFH-1);

% 1st %filterDemo(rawSignal(1:8000, 22), 22) %Piano A, A4, ideal sound
% 4th %filterDemo(rawSignal(1:8000, 10), 10) %Piano A, A3 skips 3rd Harmonization
%
% 5th %filterDemo(rawSignal(1:8000, 2), 2) %Piano B, C#3 max is 4th Harmonization
%
% 2nd %filterDemo(rawSignal(1:8000, 17), 17) %Piano C, E4 maxM is in octave above (1st Harmonization)
% 3rd %filterDemo(rawSignal(1:8000, 2), 2) %Piano C, C#3 maxM is 2nd Harmonization
