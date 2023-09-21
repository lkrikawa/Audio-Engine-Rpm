audiot=audio_data;%insert .wav data here by naming it audio_data
%user parameters
num_str=4;
num_cyl=1;
rpm_upperbound=8000;  
tlr=.1;
%sensitivity to frequency local maxes 
%(used by fft_bullet to find engine frequency)

%increase when hz values are incorrelty selecting 
%lower frequency noise

    %----------------------------------------------------------------------
engine_rpm_plotter(audiot,num_str,num_cyl,rpm_upperbound,tlr);

%Because of the way the fft slices method 
%processes a frequency, the fft slices graphs do not include a data point 
%for 0 and for the end frame of audio
%(see documentation for more)