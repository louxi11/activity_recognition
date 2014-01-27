function YHigh = parse_high_level_activity(path)

fid = fopen(fullfile(path,'activityLabel.txt'));

ts = textscan(fid,'%d %s %[^\n]','delimiter',',');

fclose(fid);

keySet = unique(ts{2});

[~,labels] = ismember(ts{2},keySet);

YHigh.vidID = ts{1};
YHigh.labels = labels;
YHigh.keySet = keySet;

end


