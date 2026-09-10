function [alpha_mat] = data_extractor(file_mic1, file_mic2,Type,Corrector)
% Based on the experimental data in file_mic1 (file where column 2 is data 
% for microphone 1 and column 3 is data for microphone 2) and file_mic2 
% (file where column 3 is data for microphone 1 and column 2 is data for 
% microphone 2) calculate the absorption coefficient for either the data 
% of the file_mic1 experiment (Type='FWD') or data of the file_mic2 
% experiment (Type='BWD'). A sensor noise correction is applied if 
% Corrector is set to true.
% 
% file_mic1, file_mic2: .txt file name
% Type: string (either "FWD" or "BWD")
% Corrector: Bool

    % Geometry parameters (impedance tube dimensions in meters)
    x_p1 = 0.055;                    % Distance from Mic 1 to sample surface
    s_12 = 0.05;                     % Microphone spacing
    
    % Acoustic calculations
    c0 = sqrt(1.4 * 286.7 * (273.15+22));  % Speed of sound in air (m/s)
    
    % Transfer function parameters
    nfft = 8192;                % Fixed block length for +/- 3Hz frequency resolution
    window = hann(nfft);        % Hanning window to prevent spectral leakage
    noverlap = nfft / 2;        % 50% window overlap to recover tapered data
    fsamp = 25000;              % Sampling frequency (Hz)
    freq_lim = 2000;            % Upper frequency limit (Hz) for Excel export
    
    % Load target experiment file
    if Type == "FWD"
        % FWD measurement
        T = readmatrix(file_mic1);
        % Selecting the relevant columns
        data = T(:,2:3);
        % Estimate uncalibrated transfer function H12FWD
        [H12FWD, freq] = tfestimate(data(:, 1), data(:, 2), window, noverlap, nfft, fsamp);
        H12 = H12FWD;

    elseif Type == "BWD"
        % BWD measurement
        Q = readmatrix(file_mic2);
        % Selecting the relevant columns
        data2 = Q(:,2:3);
        % Estimate uncalibrated transfer function H12BWD
        [H12BWD, freq] = tfestimate(data2(:, 2), data2(:, 1), window, noverlap, nfft, fsamp);
        H12 = H12BWD;

    else
        print("Error in setting type of plot")
    end

    % Apply microphone mismatch calibration correction
    if Corrector == true
        if Type == "FWD"
            % BWD measurement
            Q = readmatrix(file_mic2);
            % Selecting the relevant columns
            data2 = Q(:,2:3);
            % Estimate uncalibrated transfer function H12BWD
            [H12BWD, ~] = tfestimate(data2(:, 2), data2(:, 1), window, noverlap, nfft, fsamp);
        elseif Type == "BWD"
            % FWD measurement
            T = readmatrix(file_mic1);
            % Selecting the relevant columns
            data = T(:,2:3);
            % Estimate uncalibrated transfer function H12FWD
            [H12FWD, ~] = tfestimate(data(:, 1), data(:, 2), window, noverlap, nfft, fsamp);
        end
        
        % Calculate correction factor
        Hc_12 = sqrt(H12FWD./H12BWD);
        H12 = H12 ./ Hc_12;
    end
    
    
    % Theoretical incident (I) and reflected (R) transfer functions
    k0 = 2 * pi * freq / c0;     % Acoustic wave number (rad/m)
    H12_I = exp(-1i * k0 * s_12); 
    H12_R = exp(+1i * k0 * s_12);
    
    % Reflection coefficient at the sample surface
    r12 = (H12 - H12_I) ./ (H12_R - H12) .* exp(2i * k0 * x_p1);
    
    % Sound absorption coefficient (Alpha)
    alpha12 = 1 - abs(r12).^2;

    % Truncate frequency spectrum up to freq_lim and round values
    alpha_mat = [freq(freq<= freq_lim), round(alpha12(freq<= freq_lim),3)];
    end
   