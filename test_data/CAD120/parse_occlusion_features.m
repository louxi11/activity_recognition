function occlusion_features = parse_occlusion_features(p)

fid = fopen(fullfile(p,'occlusion_features.txt'));

ts = textscan(fid,...
  '%d %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f %*d:%f'...
  ,'delimiter',' ');

fclose(fid);

occlusion_features.vidID = ts{1};
occlusion_features.features = [ts{2:11}];

end


