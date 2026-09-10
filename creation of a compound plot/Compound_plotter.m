% First, set up the targets for the compound plot, then this will
% automatically plot the wanted figure.

clc
clear all
close all

% Define the targets using a struct array
targets(1).Folder = 'AC.2.3';
targets(1).Type = 'FWD';         
targets(1).Corrector = true;  

targets(2).Folder = 'AC.2.3 + AG.1 + BL.1';
targets(2).Type = 'BWD';         
targets(2).Corrector = true;    

targets(3).Folder = 'AC.2.3 + AG.2 + BL.1';
targets(3).Type = 'BWD';         
targets(3).Corrector = false;   

targets(4).Folder = 'AC.2.3 + BL.1';
targets(4).Type = 'BWD';         
targets(4).Corrector = true;   



% Prepare the figure for plotting, student specified only 4 targets max
my_linestyles = {'-', '--', ':', '-.'};

% All the figure data and design was made on the student's request
bgColor = [90, 35, 27] / 255; 
figure('Color', bgColor, 'Position', [100, 100, 900, 400]);
hold on;

legend_entries = cell(length(targets), 1);

% Loop through each target to extract data and plot
for i = 1:length(targets)
    
    current_folder = targets(i).Folder;
    current_type = targets(i).Type;
    current_corrector = targets(i).Corrector;
    
    % Search for all .txt files in the current folder
    txt_files = dir(fullfile(current_folder, '*.txt'));
    
    % Safety check: Ensure exactly two text files exist
    if length(txt_files) ~= 2
        error('Folder %s does not contain exactly 2 text files. It contains %d.', ...
            current_folder, length(txt_files));
    end
    
    % Extract full paths for the two files
    % because of how the student's data was set up, file_mic1 always
    % coincided with txt_files(1)
    file_mic1 = fullfile(current_folder, txt_files(1).name);
    file_mic2 = fullfile(current_folder, txt_files(2).name);
    
    % Run  data extraction function
    [alpha_mat] = data_extractor(file_mic1, file_mic2, current_type, current_corrector);
    
    % Plot the result
    plot(alpha_mat(:,1), smoothdata(alpha_mat(:,2), 1, "movmean", 100),'LineStyle',my_linestyles(i),'Color','white','LineWidth', 3);
    
    % Store the legend name
    legend_entries{i} = sprintf(current_folder);
end

 freqs_of_interest = [125, 500, 1500, 2000]; 
    xline(freqs_of_interest, '--w', 'Alpha', 0.5, 'LineWidth', 1);
    
    % Configure the axes
    ax = gca;
    ax.Color = bgColor;
    ax.XScale = 'log';
    ax.XColor = 'w';
    ax.YColor = 'w';
    ax.FontSize = 11;
    ax.FontName = 'Neue Haas Grotesk Display Pro';
    
    xlim([50 2000]);

    ax.XTick = [50, 125, 500, 1000, 1500, 2000];
    ax.YTick = 0:0.2:1.2;
    
    ax.YGrid = 'on';
    ax.XGrid = 'off';
    ax.GridColor = 'w';
    ax.GridAlpha = 0.4;
    ax.TickLength = [0 0];
    box off;

    lgd = legend(legend_entries, 'Interpreter', 'none','Location','northwest');
    
    lgd.TextColor = 'white'; 
    
    lgd.Color = 'none'; 
    lgd.Box = 'off';

    xlabel('Frequency (Hz)', ...
        'FontName', 'Neue Haas Grotesk Display Pro', ...
        'FontSize', 13, ...
        'FontWeight', 'bold', ...
        'Color', 'w');
    
    yl = ylabel('Sound Absorption coefficient', ...
        'FontName', 'Neue Haas Grotesk Display Pro', ...
        'FontSize', 13, ...
        'FontWeight', 'bold', ...
        'Color', 'w');
    yl.Units = 'normalized';
    yl.Position(1) = yl.Position(1) - 0.01;
    yl.Units = 'data'; 
    hold off;