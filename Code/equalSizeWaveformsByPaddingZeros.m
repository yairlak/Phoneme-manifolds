function phoneme_data = equalSizeWaveformsByPaddingZeros(phoneme_data)

% largest length of phoneme sample (the others will be padded to this  length)
max_length = max(cellfun(@length, phoneme_data)); 

% Pad zeros to all phoneme samples
phoneme_data = cellfun(@(x) padZeros(x, max_length), phoneme_data, 'UniformOutput', false);

end

function vec = padZeros(vec, max_length)

vec = vec(:);
vec_size  = length(vec);
vec_zeros = zeros(max_length - vec_size, 1);

vec = [vec; vec_zeros]';

end