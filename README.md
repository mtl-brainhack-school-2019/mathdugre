# Benchmark for container image size reduction strategies

Container technology is growing due to its benefit to reproducibility. However, container images are quickly growing in size growing (e.g. FMRIprep). This is problematic since data transfer time is an issue in data-intensive applications.

## Aims
Benchmark containerized data-intensive applications with size after:
- [ ] Baseline
- [ ] Neurodocker
- [ ] custom strace

## Dataset
corr dataset
<!-- cite paper or datalad -->
<!-- decide which subset -->
* 1397 subjects
* 408.4 GB
* T1, fMRI

## Methods
### BIDS App:
* example
* MAGeTbrain
* FMRIprep
* ...

### Tools:
* Baseline
* Neurodocker
* strace
* ...

### Infrastructure

Dask distirbuted, 10 dedicated 4-cores instances with 15 GB of memory with 10 Gb/s bandwidth network and a 1-core scheduler with 7.5 GB of memory.

## Future work
We want to explore new strategies to reduce the data transfer time of container image. 