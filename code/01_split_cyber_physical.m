%% 01_split_cyber_physical.m
% Split Dataset_T-ITS.csv into Cyber_Data.csv and Physical_Data.csv
% using official row ranges.

clear; clc;

% ---- Adjust path if needed ----
csvPath = fullfile('..', 'data', 'Dataset_T-ITS.csv');
if ~isfile(csvPath)
    csvPath = fullfile(getenv('USERPROFILE'), 'Downloads', 'Dataset_T-ITS.csv');
end

fprintf('Loading full dataset from:\n%s\n', csvPath);
fid = fopen(csvPath, 'r');
if fid == -1, error('Cannot open Dataset_T-ITS.csv'); end

headerLine = fgetl(fid);
allLines = {};
while ~feof(fid)
    line = fgetl(fid);
    if ischar(line)
        allLines{end+1} = line; %#ok<SAGROW>
    end
end
fclose(fid);
totalRows = numel(allLines);
fprintf('Total data rows: %d\n', totalRows);

% Cyber ranges
cyberRanges = [
    1,     9426;
    13718, 25389;
    26364, 38370;
    39345, 45028;
    50503, 53976
];

% Physical ranges
physicalRanges = [
    9427,  13717;
    25390, 26363;
    38371, 39344;
    45029, 50502;
    53977, 54784
];

cyberLines = {};
for i = 1:size(cyberRanges,1)
    for r = cyberRanges(i,1):min(cyberRanges(i,2), totalRows)
        cyberLines{end+1} = allLines{r}; %#ok<SAGROW>
    end
end

physicalLines = {};
for i = 1:size(physicalRanges,1)
    for r = physicalRanges(i,1):min(physicalRanges(i,2), totalRows)
        physicalLines{end+1} = allLines{r}; %#ok<SAGROW>
    end
end

outDir = fullfile('..', 'data');
if ~exist(outDir, 'dir'), mkdir(outDir); end

% Save Cyber
cyberFile = fullfile(outDir, 'Cyber_Data.csv');
fid = fopen(cyberFile, 'w');
fprintf(fid, '%s\n', headerLine);
for i = 1:numel(cyberLines), fprintf(fid, '%s\n', cyberLines{i}); end
fclose(fid);

% Save Physical
physicalFile = fullfile(outDir, 'Physical_Data.csv');
fid = fopen(physicalFile, 'w');
fprintf(fid, '%s\n', headerLine);
for i = 1:numel(physicalLines), fprintf(fid, '%s\n', physicalLines{i}); end
fclose(fid);

fprintf('Cyber samples    : %d -> %s\n', numel(cyberLines), cyberFile);
fprintf('Physical samples : %d -> %s\n', numel(physicalLines), physicalFile);
fprintf('Done.\n');
