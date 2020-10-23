function btstats = hierBootMatchFreq(data,nrep,lvl1,lvl2)
% btstats = hierBootMatchFreq(data,nrep,lvl1,lvl2)
%   Marina Oct 2020
%   Performs hierarchical bootstrapping on data.
%   Resamples with replacement.
%   Replicate frequency of occurrence in data.
%   Hard coded for 3 levels

%   INPUTS:
%   data - 1-d array with all data points
%   nrep - number of repetitions, recommended - 10000
%   lvl1 - grouping variable for level 1 - same size as data.
%   lvl2 - grouping variable for level 2 - same size as data.
%               
%   OUTPUTS:
%   btstats -   1-d array with length nreps. mean of the resampled
%               population for each run.

%   Example:    btstats = hierBootMatchFreq(data, 10000, lvl1_grp, lvl2_grp);

%   Based on:   Saravanan, V., Berman, G. J., & Sober, S. J. (2020).
%               Application of the hierarchical bootstrap to multi-level
%               data in neuroscience. BioRxiv. https://doi.org/10.1101/819334


%initialize variables
btstats = nan(1,nrep);

% create mapping between groups at different levels (eg which sessions
% belong to which animals)
grp1 = unique(lvl1);
ngrps1 = length(grp1);

lvls = struct();
% find next level groups that belong to the 1st level group
for k = 1:ngrps1
    lvls(k).id = grp1(k);
    grp2 = unique(lvl2(lvl1==lvls(k).id));
    ngrps2 = length(grp2);
    for n = 1:ngrps2
        lvls(k).lvl2(n).id = grp2(n);
        lvls(k).lvl2(n).neur = data(lvl2==grp2(n));
    end
end

for j = 1:nrep %loop through repetitions
    tmp = [];
    % sample with replacement level 1- generate random indices
    res1_ind = randi(ngrps1,ngrps1,1);
    
    for k = 1:length(res1_ind) %loop through level 1
        % find # of sessions per mouse
        ngrps2 = length(lvls(res1_ind(k)).lvl2);
        
        % sample with replacement level 2- generate random indices
        res2_ind = randi(ngrps2,ngrps2,1);
        for m = 1:ngrps2 % loop through sessions
            pool = lvls(res1_ind(k)).lvl2(res2_ind(m)).neur;
            res3_ind = randi(length(pool),size(pool));
            tmp = [tmp;pool(res3_ind)];
        end
    end
    
    %save mean of resampled population
    btstats(j) = mean(tmp);
end
end

