function [phoneme_data, phoneme_data_cell, phoneme_name, phoneme_index_name, ....
            phoneme_serial_place_in_sentence, phoneme_wavFile] = ...
                collectPhonemeData(params, settings, train_test, phoneme_names_TIMIT, dialect)

            % This function collects all the phonemes from the TIMIT
            % database and arrange them in a single array phoneme_data
            % together with several other arrays that keep more information
            % about the data, such as the sentence from which the phoneme
            % came, and so on. Because different phonemes have different
            % waveform sizes, all phonemes are padded with zeros to
            % achiecve equal size.
            
%%
if ~strcmp(train_test, 'TRAIN') && ~strcmp(train_test, 'TEST')
    error('Wrong input to function - choose train or test')
end
  
%%
phoneme_data_cell = cell(1); % num_samples length cell array
phoneme_data = []; % num_samples length matrix
phoneme_name = cell(1); % num_samples length cell array
phoneme_index_name = zeros(1); % num_samples length vector
phoneme_serial_place_in_sentence = zeros(1); % num_samples length vector
phoneme_wavFile = cell(1); % num_samples length cell array

%%
path2data = fullfile(settings.path2TIMITdata, train_test);

%%
sample = 1; % count how many phoneme samples in TIMIT in total

% for dialect = dialects
   curr_dialect = ['DR', num2str(dialect)];
%    fprintf('Current dialect DR%i\n', dialect)
   dialect_path = fullfile(path2data, curr_dialect);
   
   speakers = dir(dialect_path);
   isub     = [speakers(:).isdir]; %# returns logical vector
   speakers = {speakers(isub).name}';
   speakers = speakers(3:end);
   
   for spkr = 1:length(speakers)
       fprintf('Current dialect DR%i, Current speaker %s\n', dialect, speakers{spkr})
       speaker_path = fullfile(dialect_path, speakers{spkr});
       sentences    = dir(fullfile(speaker_path, '*.WAV'));
       sentences    = extractfield(sentences, 'name');
       
       for snt = 1:length(sentences)
           wav_file = fullfile(speaker_path, sentences{snt});
           [x, phonemes, endpoints] = wavReadPhonemeTimit(wav_file);
           
           for pnm = 1:length(phonemes)
               
               ind = find(ismember(phoneme_names_TIMIT,phonemes(pnm)), 1);
               begin = endpoints(pnm, 1);
               stop  = endpoints(pnm, 2);
               
               % raw data:
               if length(x(begin:stop)) < size(phoneme_data, 2);
                   pad_with_zeros = zeros(1, size(phoneme_data, 2) - length(x(begin:stop)));
                   phoneme_data(sample, :) = [x(begin:stop), pad_with_zeros]; 
               else
                   phoneme_data = horzcat(phoneme_data, zeros(sample - 1, length(x(begin:stop)) - size(phoneme_data, 2)));
                   phoneme_data(sample, :) = x(begin:stop);
               end
               phoneme_data_cell{sample} = x(begin:stop); % Raw data without zero padding
                              
               % other info:
               phoneme_name{sample, 1}  = phonemes{pnm}; % E.g., 'b'
               phoneme_index_name(sample, 1) = ind;      % E.g., '5' because 'b' is always denoted by '5'
               phoneme_serial_place_in_sentence(sample, 1) = pnm; % E.g., '10' because this time 'b' was the 10th phoneme in the sentence
               phoneme_wavFile{sample, 1} = wav_file; % path2Wav - Dialect/Speaker/Sentence
               
               sample = sample + 1;
               
%                num_samples_per_phoneme(ind) = num_samples_per_phoneme(ind) + 1;
%                phoneme_data{ind, num_samples_per_phoneme(ind), 1} = x(begin:stop); % Raw data in 1st
               % ----- Extract FEATURES and add to array -----
%                phoneme_data{ind, num_samples_per_phoneme(ind), 2} = mfcc_coef(params, x(begin:stop)); % MFCC in 2nd
               % ---------------------------------------------
%                phoneme_data{ind, num_samples_per_phoneme(ind), 2} = wav_file; % path2Wav - Dialect/Speaker/Sentence in 3rd
%                phoneme_data{ind, num_samples_per_phoneme(ind), 3} = pnm; % phoneme number in the sentence - Dialect/Speaker/Sentence in 3rd
               
               
           end
           
           
       end
   end
% end

end