#!/usr/bin/env Rscript
library(argparser)
library(neurobase)
library(ANTsR)
library(extrantsr)
library(plyr)
library(parallel)
library(pdist)
library(mclust)
source("/R/lesionclusters.R")

# # Create a parser
p <- arg_parser("Run lesion center detection method")
# Add command line arguments
p <- add_argument(p, "--outdir", help = "Output directory", default = "/tmp")
p <- add_argument(p, "--probmap", help = "Probability image", default = "probmap.nii.gz")
p <- add_argument(p, "--binmap", help = "Binary mask", default = "binmap.nii.gz")
p <- add_argument(p, "--smooth", help = "Smoothing value", default = "1.2")
p <- add_argument(p, "--minCenterSize", help = "Minium center size", default = "10")
p <- add_argument(p, "--parallel", help = "Whether to run on multiple cores", flag = T)
p <- add_argument(p, "--gmm", help = "Whether to use gaussian mixture modeling", flag = T)
# Parse the command line arguments
argv <- parse_args(p)

cores = as.numeric(Sys.getenv("CORES"))
if (is.na(cores)) {
  cores = 1
}

lesionclusters <- lesionclusters(argv$probmap, argv$binmap, smooth=argv$smooth, minCenterSize=argv$minCenterSize, gmm=argv$gmm, parallel=argv$parallel, cores=cores, c3d_path=NULL)
setwd(argv$outdir)
writenii(lesionclusters$lesioncenters, "centers.nii.gz")
writenii(lesionclusters$lesionclusters.nn, "nnmap.nii.gz")
writenii(lesionclusters$lesionclusters.cc, "clusmap.nii.gz")
if (argv$gmm) {
  writenii(lesionclusters$lesionclusters.gmm, "gmmmap.nii.gz")
}