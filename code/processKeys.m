keyNames = {'C','C#','D','D#','D','F','F#','G','G#','A','A#','B','C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
[col, row] = size(keyNames);
for i=1:row/2
   keyNames(1, (i)) = strcat(keyNames(1, (i)), '3');
end
for i=((row/2)+1):row
   keyNames(1, (i)) = strcat(keyNames(1, (i)), '4');
end

keyTable = 1:24;

[col, row] = size(rawSignal);
for i=1:row
   keyTable(i) = keyFilter(rawSignal(1:col, i));
end