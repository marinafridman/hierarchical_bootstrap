function btstats = hierBootMatchFreq_2d(data,nrep,lvl1,lvl2)
% btstats = hierBootMatchFreq_2d(data,nrep,lvl1,lvl2)

%   Marina Feb 2021

%   Performs hierarchical bootstrapping on 2-D data, yoking the sampling 
%   with replacement across the two measurements.
%   Resamples with replacement.
%   Replicate frequency of occurrence in data.
%   Hard coded for 3 levels (lvl1, lvl2, data)

%   INPUTS:
%   data - 2 x N array with all data points. 
%           Accepts 2 values for each of N samples.
%   nrep - number of repetitions, recommended - 10000
%   lvl1 - 1 x N grouping variable for level 1 (eg mouse id). 
%           can be integer or single character.
%   lvl2 - 1 x N grouping variable for level 2 (eg session id)
%           can be integer or single character.

%               
%   OUTPUTS:
%   btstats -   2 x nreps array. mean of the resampled
%               population for each run.

%   Example:    
%       data = randi(100,[2 10]);
%       lvl1_grp = [10 10 10 10 20 20 20 30 30 30]; % 3 animals
%       lvl2_grp = ['aabbcccdee']; % 5 sessions, e.g. animal 10 has 2 sessions: 'a' and 'b'
%       btstats = hierBootMatchFreq(data, 10000, lvl1_grp, lvl2_grp);

%   Based on:   Saravanan, V., Berman, G. J., & Sober, S. J. (2020).
%               Application of the hierarchical bootstrap to multi-level
%               data in neuroscience. BioRxiv. https://doi.org/10.1101/819334


%initialize variables
btstats = nan(2,nrep);

% create a structure mapping the level IDs
% (eg which sessions belong to which animals, which neurons belong to which sessions)
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
        lvls(k).lvl2(n).neur = data(:,lvl2==grp2(n));
    end
end

%perform hierarchical sampling with replacement across nreps
for j = 1:nrep 
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
            nNeur = size(pool,2);
            res3_ind = randi(nNeur,[1,nNeur]);
            tmp = [tmp,pool(:,res3_ind)];
        end
    end
    
    %save mean of resampled population
    btstats(:,j) = mean(tmp,2);
end
end

