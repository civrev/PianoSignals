close all;
load('realKeyFreqs');
s = input('1 for Piano A\n2 for Piano B\n3 for Piano C\n');
switch (s)
    case 1
        load('pianoArawSignal');
        piano='A';
        processKeys; % turns the played piano keys through keyFilter and makes a table
        keyPlotting; % preps data for plotting
    case 2
        load('pianoBrawSignal');
        piano='B';
        processKeys; 
        keyPlotting;
    case 3
        load('pianoCrawSignal');
        piano='C';
        processKeys; 
        keyPlotting; 
    otherwise
        fprintf('Invalid Selection\n' );
end