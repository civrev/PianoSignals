%if it's Piano B, do this
if piano=='B'
keyTable(1)=130;
end
stem(keyTable, 'filled');
hold on;
stem(realKeyFreqs, '*');
title('Keys and their Frequencies: Piano ' + string(piano));
ylabel('Frequencies');
yt = unique(sort(keyTable));
yticks(yt);
yticklabels(string(keyNames) + ' ' + yt + string('Hz'));
ylim([min(keyTable), max(keyTable)]);
xlabel('Keys/Notes');
xticks(1:24);
xticklabels(keyNames);
%grid on;
hold off;