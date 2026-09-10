# impedance-tube-data-processing
MATLAB tools for extracting, processing and plotting of sound absorption coefficient curves from two-microphone impedance tube experiments

## Overview
All the tools basically revolve around 'data_extractor.m'. It takes two impedance tube tests, with the same sample but reversed microphone positions (i.e. microphone 1 is in position 1 for test 1, but is in position 2 for test 2), such that it can use those two tests to filter out the sensor noise (In the case that correction=true).

'impedance_tube_auto_plotter.m' will scan the repository for all files, and where applicable will generate the plot for every experimnent. This is very convenient in the case where there are a lot of experiments present. processing of a lot of individual folders contains an example where this is done.

'Compound_plotter.m' on the other hand, works on selected experiments, and creates a compound plot containing the selected experiments, which is optimal for comparison in a report. creation of a compound plot folder contains an example where this is done.

All the figures are created according to the request of the student who requested these codes.

## Usage
To use the two automation scripts, ensure your data is organized into folders, with one folder corresponding to one experiment. Each folder should contain two files, one for each experiment.