Engine Rpm README
By Liam Krikawa


The project contains two versions of a matlab program that takes in audio of an engine and outputs an engine rpm. It uses the frequency of the sound of the engine to calculate rpm using the number of cylinders and strokes. To see more visit https://sites.google.com/view/audio-engine-rpm 


The first version (3 files recorded_engine_rpm.m, engine_rpm_plotter.m, and fft_bulletV2.m ) takes in an audio recording.

The second version live engine rpm.mlx does it live using the microphone input from your computer.

-----------------------------------------------------------------------------------------------------
How to use the pre-recorded audio version of Engine Rpm:

Make sure recorded_engine_rpm.m, engine_rpm_plotter.m, and fft_bulletV2.m are in the same folder and open in matlab.


Parameters

Number of cylinders (num_cyl)
Number of strokes (num_str)
These can be found by looking up your engine model.
 
Rpm upper bound (rpm_upperbound) 
This is the highest rpm value you expect your rpm to be. You can always change this later so if you don’t know make your best guess. The upper bound is important because the correct upper bound allows the spectrogram to ignore any higher frequency harmonics. It will also make the spectrogram run faster.


Tolerance (tlr)
This is a noise tolerance to pick the correct time frequency ‘ridge’ in the spectrogram. Play around with it if the program isn’t picking anything up or is picking noise. It can be any value between 0 and 1.



The next step is Import your audio data
You can do this using the import button in matlab. 
The program needs a 44.1kHz sample rate .wav file. Audacity can convert most audio types into a 44.1kHz .wav.


You can use the command below in the command line to change the name of your data to audio_data so that the program will run.


audio_data=[insert name of data];


The program will generate 4 graphs: a spectrogram, an graph of rpm created by picking values off of the spectrogram (green), a graph of rpm made using a method I developed (red), and all of the plots over-layed. 


Limitations:
The program is impacted by noise other than the engine. Try your best to make the engine the loudest and only sound in the recording.

The spectrogram gets ‘warped’ because of the resolution; this is most noticeable at the start and end of a spectrogram that is graphing a rapidly changing engine rpm. The red line (graphed using my algorithm) is the most accurate and is accurate within +/-15 for the average case.

-----------------------------------------------------------------------------------------------------
How to use the live version of Engine Rpm:
Open live_engine_rpm.mlx in Matlab and undock it (its easier to use that way)
Hide the code so that the output is visible

live_engine_rpm.mlx has the pretty much the same parameters as the non live version
The only difference is duration which is the number of seconds you want to record after pressing run.

The live is accurate within +/- 25rpm for the average case.