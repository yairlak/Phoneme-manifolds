clear all; close all; clc
%%
[params, settings] = load_params_settings();
dialect = 1;
train_test = 'TEST';

%%
file_name = sprintf('phonemeTimit_waveforms_paddedZeros_Dialect%i_%s.mat', dialect, train_test);
load(fullfile(settings.path2output_phonemes, file_name), 'phoneme_data', 'phoneme_name', 'phoneme_index_name', 'phoneme_serial_place_in_sentence')

%%
num_samples = size(phoneme_data, 1);
for sample = 1:num_samples
    
    % Print current sample to screen
    if mod(sample, 100) == 1
        fprintf('sample number %i out of %i\n', sample, num_samples)
    end

        
    % Calculate MFCC for current sample:
    [mfcc, ~] = melfcc(phoneme_data(sample, :) * params.constant, params.sampling_rate, ...
                       'maxfreq', 8000, ...
                       'numcep', params.num_mel_filters, ...
                       'nbands', 22, ...
                       'fbtype', 'fcmel', ...
                       'dcttype', 1, 'usecmp', 1, ...
                       'wintime', 0.032, ...
                       'hoptime', 0.016, ...
                       'preemph', 0, ...
                       'dither', 1);

    % Take deltas and delta-deltas
    window_size_delta = 9;
    del = deltas(mfcc, window_size_delta);
    % Double deltas are deltas applied twice with a shorter window
    window_size_delDelta = 5;
    ddel = deltas(deltas(mfcc, window_size_delDelta), window_size_delDelta);
    % Composite, 39-element feature vector, just like we use for speech recognition
    mfcc = [mfcc; del; ddel];

    % put back in array
    phonemes_MFCC(sample, :) = mfcc(:)';

    clear mfcc

end

% Save
file_name = sprintf('phonemeTimit_MFCCs_Dialect%i_%s.mat', dialect, train_test);
save(fullfile(settings.path2output_MFCCs, file_name), 'phonemes_MFCC', 'phoneme_name', 'phoneme_index_name', 'phoneme_serial_place_in_sentence', '-v7.3')
