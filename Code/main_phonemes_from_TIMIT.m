% -------------------------------------------
% This script parses the TIMIT database into phonemes.
% The TIMIT database should be in '../Data' folder.
% The output is saved into '../Output' folder. Make sure this folder
% exists!
clear all; close all; clc

%% settings & params
[params, settings] = load_params_settings();
dialect = 1; % Dialect in TIMIT can take a value of 1-8
%settings.calc_MFCCs; % Whether to calculate MFCC values for phonemes

%% data
load(fullfile('..', 'Data', 'phoneme_names_TIMIT.mat'))

%% Parse TIMIT sentences into single phonems
train_test = 'TEST';
[phoneme_data, phoneme_data_cell, phoneme_name, phoneme_index_name, ....
            phoneme_serial_place_in_sentence, phoneme_wavFile] = ...
                    collectPhonemeData(params, settings, train_test, phoneme_names_TIMIT, dialect);

%% Save to folder                
file_name = sprintf('phonemeTimit_waveforms_paddedZeros_Dialect%i_%s.mat', dialect, train_test);
save(fullfile(settings.path2output_phonemes, file_name), 'phoneme_data', 'phoneme_data_cell', ...
                         'phoneme_name', 'phoneme_index_name', ....
                    'phoneme_serial_place_in_sentence', 'phoneme_wavFile', '-v7.3')
