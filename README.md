# hierarchical_bootstrap

Matlab implementation of hierarchical bootstrapping algorithm described in [Saravanan et al 2019](https://www.biorxiv.org/content/10.1101/819334v2.full). 

Based on [the Hierarchical_bootstrap_Matlab repository](https://github.com/jenwallace/Hierarchical_bootstrap_Matlab) and [the original code in Python](https://github.com/soberlab/Hierarchical-Bootstrap-Paper). Extends previous implementations by allowing any number of grouping levels.

## Details
* Performs hierarchical bootstrapping on data.
* Resamples with replacement.
* Does not replicate frequency of occurrence in data.
* Can handle an arbitrary # of levels

## Usage
**INPUTS:**
* `data` - 1-d array with all data points
* `nrep` - number of repetitions, recommended - 10000
* `varargin` -  grouping variables with same size as data. 1st variable corresponds to first level, 2nd to second level, and so on.

**OUTPUTS:**
* `btstats` -   1-d array with length nreps. mean of the resampled population for each run.
 
**Example:**
```matlab
btstats = hierBoot(data, 10000, lvl1_grp, lvl2_grp);
```
