# impedance-tube-data-processing
MATLAB tools for extracting, processing and plotting of sound absorption coefficient curves from two-microphone impedance tube experiments. 
Written in MATLAB 2024a.

## Overview
All the tools basically revolve around 'data_extractor.m'. It takes two impedance tube tests, with the same sample but reversed microphone positions (i.e. microphone 1 is in position 1 for test 1, but is in position 2 for test 2), such that it can use those two tests to filter out the sensor noise (In the case that correction=true).

'impedance_tube_auto_plotter.m' will scan the repository for all files, and where applicable will generate the plot for every experimnent. This is very convenient in the case where there are a lot of experiments present. processing of a lot of individual folders contains an example where this is done.

'Compound_plotter.m' on the other hand, works on selected experiments, and creates a compound plot containing the selected experiments, which is optimal for comparison in a report. creation of a compound plot folder contains an example where this is done.


All the figures are created according to the request of the student who requested these codes.

## Usage
To use the two automation scripts, ensure your data is organized into folders, with one folder corresponding to one experiment. Each folder should contain two files, one for each experiment.

## Mathematics
'data_extractor.m' applies the standard transfer function method to determine the absorption coef.
*Data regarding the microphone 1 and microphone 2 is extracted. these values should be in [mV/m/s^2]. From these values, we need to obtain the transfer functions, so we readily use MATLAB's built in tfestimate.
*Then, if correction=true:
  $$H_c = \sqrt{\frac{H_{12,FWD}}{H_{12,BWD}}}$$
  
where $H_{12,FWD}$ and $H_{12,BWD}$ are the transfer functions from the forward and backward microphone measurements.
This step is done to filter out amplitude and phase mismatch between the two microphones.


*The theoretical incident ($H_{12,I}$) and reflected ($H_{12,R}$) transfer functions are defined using the acoustic wavenumber $k_0$. (NOTE: $s_{12}$ defines the distance between the two microphones. In the presented experimental data this distance was fixed at 0.05m)
   $$H_{12,I} = e^{-i k_0 s_{12}}$$
   $$H_{12,R} = e^{+i k_0 s_{12}}$$


* Finally, we can calculate the complex reflection coefficient:
   $$r_{12} = \frac{H_{12} - H_{12,I}}{H_{12,R} - H_{12}} e^{2i k_0 x_{p1}}$$
  
Here, $x_{p1}$ defines the distance between the sample and the microphone in position 1. (NOTE: in the experimental setup this was fixed at 0.055m).


* And lastly:
   $$\alpha_{12} = 1 - |r_{12}|^2$$
