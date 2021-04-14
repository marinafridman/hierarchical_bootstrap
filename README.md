# hierarchical_bootstrap

Matlab implementation of hierarchical bootstrapping algorithm described in [Saravanan et al 2019](https://www.biorxiv.org/content/10.1101/819334v2.full). 

Based on [the Hierarchical_bootstrap_Matlab repository](https://github.com/jenwallace/Hierarchical_bootstrap_Matlab) and [the original code in Python](https://github.com/soberlab/Hierarchical-Bootstrap-Paper). Extends previous implementations by allowing any number of variables.

## Details

hierBootMatchFreq.m
* Performs hierarchical bootstrapping on data.
* Resamples with replacement.
* Replicate frequency of occurrence (per mouse/per session/etc) in data.
* Can handle three levels
* Closer to what is in the paper and previous implementations

hierBootMatchFreq_2d.m
* Extends application to 2+ variables that are yoked acorss resampling 

hierBoot.m
* Performs hierarchical bootstrapping on data.
* Resamples with replacement.
* Does not replicate frequency of occurrence in data.
* Can handle an arbitrary # of levels
* NOT RECOMMENDED


## Usage
**INPUTS:**
* `data` - 1-d array with all data points
* `nrep` - number of repetitions, recommended - 10000
* `varargin` -  grouping variables with same size as data. 1st variable corresponds to first level, 2nd to second level, and so on.

**OUTPUTS:**
* `btstats` -   1-d array with length nreps. mean of the resampled population for each run.
 
**Example:**
```matlab
btstats = hierBootMatchFreq(data,nrep,lvl1,lvl2);
```
