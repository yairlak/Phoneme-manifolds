function [params, settings] = load_params_settings(settings, params)

%% General params
params.seed_split = 1;

%% params MFCC:
params.sampling_rate   = 16000;
params.window_width    = 25;     %in miliseconds
params.num_fft         = 512;    % The number of coef's is this number divided by 2 plus 1.

params.num_mel_filters = 24;  
params.lowest_freq     = 300;    % in Hz
params.highest_freq    = 8000;   % in Hz

% constant = 3.3752;
params.constant = 1; % !!!! WHY COLUMBIA MFCC Algorithm USES THIS CONSTANT? !!!

%% paths TIMIT:
settings.path2TIMITdata = fullfile('..', 'Data');
settings.path2TIMITdata = '/cortex/data/sound/speech/TIMIT/timit/TIMIT';
settings.path2output_phonemes    = fullfile('..', 'Output_phonemes');
settings.path2output_MFCCs     = fullfile('..', 'Output_MFCCs');
% settings.path2save   = '/cortex/users/yairlak/phonemeTIMIT';


%% Methods
settings.initFinal         = 'init'; % (init/final) Similarity determined from confusion according to begining/ending of the presented words.
settings.SNR               = '5N'; % SNR in experiment (see function - confusionMat(init_final, SNR))
% settings.rowIndiceFeatures = 1:23; % Takes only a subset of the feature matrix
settings.rowIndiceDist     = 1:22; % Takes only a subset of the confusion matrix

%% Features
settings.train_test = 'TEST'; % Which folder in TIMIT database

settings.featureNames_Articulatory  = {'Place'; 'Sonority'; 'Manner'; 'Vocality'};
settings.featureNames_MFCC  = {'MFCC1'; 'MFCC2'; 'MFCC3'; 'MFCC4';'MFCC5'; 'MFCC6'; 'MFCC7'; 'MFCC8';'MFCC9'; 'MFCC10'; 'MFCC11'; 'MFCC12';'MFCC13'; 'MFCC14'; 'MFCC15'; 'MFCC16';'MFCC17'; 'MFCC18'; 'MFCC19'; 'MFCC20';};
settings.featureSubset = [];
if ~isempty(settings.featureSubset)
    settings.featureNames = settings.featureNames(settings.featureSubset);
end

%% Lasso
settings.lambda_orders = [-3 -2 -1 0 1 2 3];
settings.lambda_values = 1:9;
settings.crossValidationKfold = 22;

%% What to view
settings.viewWeights   = true;
settings.viewErrors    = true;

%% phoneme order
settings.phonemes = {'p', 't', 'k', 'b', 'd', 'g', 'C', 'J', 's', 'S', 'z', 'f', 'T', 'v', 'D', 'h', 'n', 'm', 'l', 'r', 'w', 'y', 'noResponse'}';

end
