function subjects = parse_subject(subject_path)

subject_folders = dir(fullfile(subject_path,'Subject*_annotations'));

subjects = cell(size(subject_folders));

for s = 1 : length(subjects)

    % find all activity directories under subjects
    activity_folders = dir(fullfile(subject_path,subject_folders(s).name));
    nameFolds = {activity_folders.name}';
    activity_folders(ismember(nameFolds,{'.','..'})) = [];
    
    for a = 1 : length(activity_folders)
        
        % full path of the activity label
        file = fullfile(subject_path,subject_folders(s).name,activity_folders(a).name,'activityLabel.txt');
        
        % parse label file to find video ids
        fid = fopen(file);
        ts = textscan(fid,'%d%[^\n]');
        videos = ts{1};
        fclose(fid);
        
        % save video ids
        subjects{s} = [subjects{s};videos];
        
    end
    
end

assert(~isempty(subjects))

% % check uniqueness of video ids among subjects
% clc
% for s = 1 : length(subjects) - 1
%     for s1 = s + 1 : length(subjects)
%         assert(isempty(intersect(subjects{s},subjects{s1})))
%     end
% end
% fprintf('\nDONE\n')