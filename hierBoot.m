function btstats = hierBoot(data,nrep,varargin)
% btstats = hierBoot(data,nrep,varargin)
%   Marina Oct 2020
%   Performs hierarchical bootstrapping on data.
%   Resamples with replacement.
%   Does not replicate frequency of occurrence in data.
%   Can handle an arbitrary # of levels

%   INPUTS:
%   data - 1-d array with all data points
%   nrep - number of repetitions, recommended - 10000
%   varargin -  grouping variables with same size as data.
%               1st variable corresponds to first level, 2nd to second
%               level, and so on.
%   OUTPUTS:
%   btstats -   1-d array with length nreps. mean of the resampled
%               population for each run.

%   Example:    btstats = hierBoot(data, 10000, lvl1_grp, lvl2_grp);

%   Based on:   Saravanan, V., Berman, G. J., & Sober, S. J. (2020).
%               Application of the hierarchical bootstrap to multi-level
%               data in neuroscience. BioRxiv. https://doi.org/10.1101/819334

lvls = varargin;
lvls{end+1} = data; % adds data as last level

%initialize variables
btstats = nan(1,nrep);
nsamp = length(data);
lvls_j = cell(size(lvls));

for j = 1:nrep %loop through repetitions
    % sample with replacement level 1- generate random indices
    res_ind = randi(nsamp,size(data));
    
    % index into level 1
    lvls_j{1} = lvls{1}(res_ind);
    
    for m = 1:length(lvls)-1 % loops through all grouping levels (leaves out last data level)
        %initialize variable for next level
        lvls_j{m+1} = nan(size(data));
        
        % loop through groups of level (eg same animal,session, etc)
        for k = 1:length(unique(lvls_j{m}))
            % find all instances of next level belonging to current level group - this is
            % the pool
            pool =  lvls{m+1}(lvls{m} == k);
            
            % sample with replacement next level - generate indices
            res_ind = randi(length(pool),sum(lvls_j{m} == k),1);
            
            % populate with re-indexed samples
            lvls_j{m+1}(lvls_j{m} == k) = pool(res_ind);
        end
    end
    
    %save mean of resampled population
    btstats(j) = mean(lvls_j{end});
end
end

