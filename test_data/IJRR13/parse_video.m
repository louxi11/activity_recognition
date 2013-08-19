function [sfile,tfile] = parse_video(vidfile)

% open segment file
fid = fopen(vidfile);

% number of subsegments
s = textscan(fid,'%d',2);

% get sub-segment feature filenames
segs = textscan(fid,'%s');

assert(sum(s{1}) == length(segs{1}))
assert(s{1}(1) == s{1}(2) + 1)

sfile = segs{1}(1:s{1}(1));

tfile = segs{1}(s{1}(1)+1:end);

fclose(fid);

end