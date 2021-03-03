# BEEP NOTE
by Philip Kobernik

adapted from code by Yon Visell, prepared for ECE 130B, Winter 2021, UC Santa Barbara

## Description
This piece is a riff on the THX Deep Note trademark sound composition by James A. Moorer.
(https://en.wikipedia.org/wiki/Deep_Note)


It uses 15 voices, each with 24 harmonics. The voices start in a jumbled mess around 250-400 hz, then slowly glide to a large multi-octave chord (mixture of octaves and 5ths).

The low-end voices are square waves, and the mids and high voices are sawtooth waves.

Aliasing is avoided by simply removing harmonics that would dare glide above Nyquist frequency (half of sample rate).

## How to run
Open the folder in MATLAB. Open beep_note.m, press `Run` button. This script saves the synthesized audio as `beep_note.wav` in your working folder.

## Variables of note
`duration` : adjust to change length of synthesized piece. Durations longer than 60 will re-wire your brain.

`num_voices` : change to 1 to only have one voice (it will be lowest voice)

`num_harmonics` : change to 1 to only use the fundamental tone of each voice

`voices_ending_freq` : update this array of frequencies to create a new chord voicing for the final resolution

## Spectrogram
![Spectrogram](http://raw.githubusercontent.com/philipkobernik/beep_note/main/beep_note_spectrogram.png)
