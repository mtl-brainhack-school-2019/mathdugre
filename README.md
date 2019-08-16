# Benchmark of container's image size reduction strategies

Container technologies are growing due to their benefits to reproducibility and deployement. However, The growing size of container's image (e.g. FMRIprep is ~15GB) is problematic since data transfer takes a considerable amount of time in data-intensive applications [\[1\]](https://arxiv.org/pdf/1907.13030.pdf). We study strategies to reduce data transfer time for container image. As a first appraoch, we aim at minimizing the image size of container with neurodocker and strace. This will help us determine if further effort should be invested to optimise transfer of container's image.

## Material and Methods

### Dataset
[corr dataset](http://fcon_1000.projects.nitrc.org/indi/CoRR/html/)
* 1397 subjects
* 408.4 GB
* T1, fMRI

TODO:
- [ ] Selection a subset of subjects

### Tools used:
* ![Bash](https://tiswww.case.edu/php/chet/img/bash-logo-web.png){:height="100px"}
* ![Docker](https://cdn.worldvectorlogo.com/logos/docker.svg){:height="100px"}
* ![Singularity](https://singularity.lbl.gov/images/logo/logo.svg){:height="100px"}
* ![Dask](https://dask.org/_images/dask_horizontal_white_no_pad.svg){:height="100px"}

### BIDS App:
* example
* MAGeTbrain
* FMRIprep
* ...

### Aproach:
* Reduce image size with:
    - ~~[ ] Neurodocker (Complete)~~ (Removed due to issues when building container images)
    - ~~[ ] Neurodocker (Whithelist)~~ (Container fails to build with the dependency. Raise an [issue](https://github.com/kaczmarj/neurodocker/issues/295) to neurodocker)
    - [ ] Custom bash script using [reprozip](https://www.reprozip.org/)
    - [ ] Custom bash script using [strace](https://linux.die.net/man/1/strace)
* Convert Docker image with [docker2singularity](https://hub.docker.com/r/singularityware/docker2singularity)
* Benchmark the baseline versus the different reduce methods

### Infrastructure

A 1-core scheduler with 7.5GB of memory with the Dask distributed scheduler and 10 dedicated 4-cores workers with 15GB of memory connected by a 10Gb/s network bandwidth.

## Future work
We want to explore new scheduling and access strategies to reduce data transfer time of container's image.

## Deliverable
- [ ] Script to minify image's size of container.
- [ ] Minified images
- [ ] Benchmark report on the impact of minimizing image's size of container.
- [ ] Interactive gantt chart for the execution of the pipelines