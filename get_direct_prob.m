function [p_boot, p_joint_matrix] = get_direct_prob(sample1, sample2)
% [p_boot, p_joint_matrix] = get_direct_prob(sample1, sample2)get_direct_prob
%       Returns the direct probability of items from sample2 being
%       greater than or equal to those from sample1.
%        Sample1 and Sample2 are two bootstrapped samples and this function
%        directly computes the probability of items from sample 2 being greater
%        than or equal to those from sample1. Since the bootstrapped samples are
%        themselves posterior distributions, this is a way of computing a
%        Bayesian probability. The joint matrix can also be returned to compute
%        directly upon.[p_boot, p_joint_matrix] = get_direct_prob(sample1, sample2)

%   Based on python function of the same name defined in
%   https://github.com/soberlab/Hierarchical-Bootstrap-Paper/blob/master/Bootstrap%20Paper%20Simulation%20Figure%20Codes.ipynb

% make bin edge vector taking into account spread of both samples
nbins = 100; % # of bins
joint_low_val = min([min(sample1),min(sample2)]);
joint_high_val = max([max(sample1),max(sample2)]);

p_axis = linspace(joint_low_val,joint_high_val,nbins);
edge_shift = (p_axis(2) - p_axis(1))/2;
p_axis_edges = p_axis - edge_shift;
p_axis_edges(end+1) = (joint_high_val + edge_shift);

%Calculate probabilities using histcounts for edges.
p_sample1 = histcounts(sample1,'binedges',p_axis_edges,'Normalization','probability');
p_sample2 = histcounts(sample2,'binedges',p_axis_edges,'Normalization','probability');

%calculate the joint probability matrix:
p_joint_matrix = zeros([nbins,nbins]);
for j = 1:nbins
    for k = 1:nbins
        p_joint_matrix(j,k) = p_sample1(j)*p_sample2(k);
    end
end

%normalize the joint probability matrix:
p_joint_matrix = p_joint_matrix/sum(p_joint_matrix(:));

% Get the volume of the joint probability matrix in the upper triangle:
p_boot = sum(p_joint_matrix(triu(true(nbins),1)));
end

