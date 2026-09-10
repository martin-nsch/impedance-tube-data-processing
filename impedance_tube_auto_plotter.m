function impedance_tube_auto_plotter()
% Automatic scanning of all the sub-folders in the folders this function is
% located in, and then processing of all the data.
% The data is processed with data_extractor and then plotted according to
% the students specifications. A pdf file of the constructed figures is
% saved.
    
    % Variables needed for data_extractor
    Type = ["FWD","BWD"];
    Corrector = true;

    % Get all items in the current directory
    contents = dir();
    
    % Filter to keep only directories, ignoring the default '.' and '..'
    isFolder = [contents.isdir];
    folders = contents(isFolder);
    folders = folders(~ismember({folders.name}, {'.', '..'}));
    
    % Loop through each folder
    for i = 1:length(folders)
        folderName = folders(i).name;

        % Look for all files ending in .txt in this folder
        txtFiles = dir(fullfile(folderName, '*.txt'));
        
        % Check if the folder contains at least two text files
        if length(txtFiles) >= 2
            
            % Extract the full paths for the first two text files found
            % In this specific case, the microphone 2 experiments always
            % coincided with txtFilse(2) and microphone 1 experiments
            % coincided with txtFiles(1)
            file1 = fullfile(folderName, txtFiles(1).name);
            file2 = fullfile(folderName, txtFiles(2).name);
            
            % Close any open figures so we only capture the new ones
            close all;
            
            % Call your original plotting function
            for j = 1:2
                [alpha_mat] = data_extractor(file1, file2, Type(j), Corrector);
                plottime(alpha_mat,Type(j))
            end

            % Find all currently open figure windows
            figs = findall(0, 'Type', 'figure');
            
            % Sort the figures by their Figure Number (so Figure 1 is saved first)
            [~, idx] = sort([figs.Number]);
            figs = figs(idx);

            % Loop through each generated figure and save it
            for j = 1:length(figs)

                % Dynamic file name allocation
                pdfName = sprintf('%s_%d.pdf', folderName, j);
                outputPdf = fullfile(folderName, pdfName);

                %  Force text to Helvetica to avoid font substitution
                set(findall(figs(j), '-property', 'FontName'), 'FontName', 'Helvetica');

                % Export the specific figure handle (figs(j))
                exportgraphics(figs(j), outputPdf, 'ContentType', 'vector', 'BackgroundColor', 'current');
            end
            
            close all;
            
            fprintf('Processed and saved %d PDFs in folder: %s\n', length(figs), folderName);
        else
            fprintf('Skipped folder "%s": Found fewer than two .txt files.\n', folderName);
        end
    end
    disp("Processing of all folders concluded.")
end

function [] = plottime(alpha_mat, Type)
    % Plots the experimental data with the specifications provided by the
    % student

    % Generate figure
    bgColor = [167, 93, 59] / 255; 
    figure('Color', bgColor, 'Position', [100, 100, 900, 400]);
    hold on;
    
    % Plot the main data line
    plot(alpha_mat(:,1), smoothdata(alpha_mat(:,2), 1, "movmean", 100),'w-','LineWidth', 3);
    
    % Configure title
    title(Type, ...
    'FontName', 'Neue Haas Grotesk Display Pro', ...
    'FontSize', 15, ... 
    'FontWeight', 'bold', ...
    'Color', 'w');
    
    % POI defined by the student
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
    
    % Set axis limits
    xlim([50 2000]);
    ylim([0 1]);
    
    % Set ticks
    ax.XTick = freqs_of_interest;
    ax.YTick = 0:0.2:1.2;
    
    % Grid n ticks
    ax.YGrid = 'on';
    ax.XGrid = 'off';
    ax.GridColor = 'w';
    ax.GridAlpha = 0.4;
    ax.TickLength = [0 0];
    box off;                      
    
    % Custom font time
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
end