% BEEP NOTE
% by Philip Kobernik
%
% adapted from code by Yon Visell, prepared for
% ECE 130B, Winter 2021, UC Santa Barbara

fs = 44100;
ts = 1/fs;
duration = 50;
decay = 0.5;
tt_whole = 0:ts:duration;
tt_converge = 0:ts:.5*duration;
tt_fade_out = (.5*duration+ts):ts:duration+ts;
num_voices = 15;
num_harmonics = 24;

voices_starting_freq = (rand(num_voices,1) * 150) + 250;
voices_ending_freq = [ 73; 73; 73; 146; 146; 146; 292; 292; 584; 584; 1022; 1533; 2044; 3066; 4088; ];

converge_part = zeros(size(tt_converge));
fade_out_part = zeros(size(tt_fade_out));

eliminated_harmonics = 0;

for nv = 1:num_voices
    voice_harmonic_weight = 1./((1.00 + nv*0.2)*(1:num_harmonics))';
%     figure(nv);
%     plot(voice_harmonic_weight);
%     title("plot voice  " + nv);
    amps = voice_harmonic_weight + 0.0 * randn(num_harmonics, 1);
    decay_harm = decay * (1:num_harmonics)'.* (1.0 + 0.00*randn(num_harmonics, 1));
    freq_harm_start = voices_starting_freq(nv) * (1:num_harmonics)'.* (1.0 + 0.001 * randn(num_harmonics,1));
    freq_harm_end = voices_ending_freq(nv) * (1:num_harmonics)'.* (1.0 + 0.001 * randn(num_harmonics,1));
        
    for nh = 1:num_harmonics        
        if freq_harm_end(nh) < fs/2
            freq_movement = easing(0:length(tt_converge)-1, freq_harm_start(nh), (freq_harm_end(nh)-freq_harm_start(nh)), length(tt_converge), 2);
            phase_in = cumsum(freq_movement/fs);
                
            if voices_ending_freq(nv) < 200 % bass note
                if mod(nh, 2) == 1 % only odd harmonics, 1/harmonic_index weight
                    harmonic_layer = (1/nh) * attack_env(tt_converge, fs) .* sin(2*pi*phase_in);
                    converge_part = converge_part + harmonic_layer;
                end
            else
                harmonic_layer = amps(nh) .* attack_env(tt_converge, fs) .* sin(2*pi*phase_in);
                converge_part = converge_part + harmonic_layer;
            end

        else
            eliminated_harmonics = eliminated_harmonics + 1;
        end
    end

end

eliminated_harmonics_above_nyquist_freq = eliminated_harmonics

for nv = 1:num_voices
    voice_harmonic_weight = 1./((1.00 + nv*0.2)*(1:num_harmonics))';
    amps = voice_harmonic_weight + 0.0 * randn(num_harmonics, 1);
    decay_harm = decay * (1:num_harmonics)'.* (1.0 + 0.1*randn(num_harmonics, 1));
    freq_harm = voices_ending_freq(nv) * (1:num_harmonics)'.* (1.0 + 0.001 * randn(num_harmonics,1));
        
    for nh = 1:num_harmonics
        if freq_harm(nh) < fs/2
            if voices_ending_freq(nv) < 200 % bass note
                if mod(nh, 2) == 1 % only odd harmonics, 1/harmonic_index weight
                    harmonic_layer = (1/nh) * exp(-decay_harm(nh)*tt_converge) .* sin(2*pi*(freq_harm(nh).*tt_fade_out));
                    fade_out_part = fade_out_part + harmonic_layer;
                end
            else
                harmonic_layer = amps(nh) .* exp(-decay_harm(nh)*tt_converge) .* sin(2*pi*(freq_harm(nh).*tt_fade_out));
                fade_out_part = fade_out_part + harmonic_layer;
            end
        end
    end

end

fade_length = 10000;
for nf = 1:fade_length
    % fade end of converge_part into beginning of fade_out_part
    weight_growing = nf/fade_length;
    weight_declining = 1-weight_growing;
    % linear cross-fade
    converge_part(end-fade_length+nf) = weight_declining * converge_part(end-fade_length+nf) + weight_growing * fade_out_part(nf);
end

% the first fade_length samples of fade_out_part
% have been mixed into the end of converge_part
final = [converge_part fade_out_part(fade_length+1:end)];

filtered_beep_note = lpf_sweep_open(final, 1.5, fs);

filtered_beep_note = filtered_beep_note/max(abs(filtered_beep_note)); % normalize

soundsc(filtered_beep_note, fs);

filename = 'beep_note.wav';
audiowrite(filename,filtered_beep_note,fs);

function yy = attack_env(in, fs)
    yy = 1 + -exp(-1*in*0.0001*fs);
end
