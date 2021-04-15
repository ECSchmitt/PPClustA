
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PPClustA

<!-- badges: start -->
<!-- badges: end -->

The PPClustA package contains a shiny APP to explore and visualize Gene
expression data of Acute Lymphatic Leukemia (ALL) and Acute Myeloid
Leukemia (AML) patients from Golub et al. applying Principal Component
Analysis and Hierarchical Clustering methods.

## Required Packages

-   [cluster](https://cran.r-project.org/package=cluster)
-   [diplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
-   [ggfortify](https://cran.r-project.org/package=ggfortify)
-   [GolubEsets](https://doi.org/doi:10.18129/B9.bioc.golubEsets)
-   [Shiny](https://shiny.rstudio.com/)
-   [tibble](https://www.rdocumentation.org/packages/tibble/versions/3.1.0)

## Installation

You can install the current version of PPClustA from
[GitHub](https://github.com/ECSchmitt/PPClustA) using
[devtools](https://cran.r-project.org/web/packages/devtools/index.html)
install\_github() function:

``` r
if(!requireNamespace("devtools", quietly = TRUE))
  install.packages("devtools")
  
devtools::install_github("ECSchmitt/PPClustA")
```

## Introduction

Looking at [expression
data](https://en.wikipedia.org/wiki/Gene_expression_profiling) of many
genes across many individuals we are confronted with a vast amount of
information. Such data is multidimensional and therefore needs to be
simplified to become comprehensible to us without losing important
information. In case of the Golub data the authors were interested in
finding and distinguishing new cancer sub-types. But how can we use
expression data to define cancer sub-types?

### Measuring Distances

To tackle this problem we need to find a measure allowing us to
determine similarities between the expression
[vectors](https://en.wikipedia.org/wiki/Vector_(mathematics_and_physics))
per patient and gene enabling us to group similar vectors together. A
measure providing this functionality is the distance between two
vectors. Similar distances indicate closer feature vectors within vector
space. A few example for such measures are:

-   [Euclidean](https://en.wikipedia.org/wiki/Euclidean_distance)
-   [Manhattan](https://en.wikipedia.org/wiki/Taxicab_geometry)
-   [Maximum](https://en.wikipedia.org/wiki/Chebyshev_distance)
-   [Minkowski](https://en.wikipedia.org/wiki/Minkowski_distance)

To calculate a distance matrix you need some kind of input that the
dist() function of R can handle. Such an input is either a two
dimensional matrix or a vector. Both have to have numeric types. A
random 6\*6 numerical matrix can be produced as follows

``` r
#producing a 6*6 matrix with random values
matrix <- matrix(rnorm(36), nrow = 6)
```

    #>            [,1]        [,2]       [,3]         [,4]       [,5]       [,6]
    #> [1,] -0.8316770 -0.32777338  0.7895983  0.252647836  0.8519514 -0.6237336
    #> [2,] -0.2608489 -0.97399357 -0.4872362 -0.150969246  0.7971430 -0.1867314
    #> [3,]  2.4752612  1.52436404 -1.3972125 -0.213666986  1.3209266 -0.2560233
    #> [4,]  1.9830862 -2.48082876  0.1827952  0.002833884 -0.2586679 -0.5761536
    #> [5,]  2.4970150 -0.18868647  1.3523666  1.338565436 -2.2276366  1.2692404
    #> [6,] -1.0020344  0.05276695  0.7229029 -0.330745530  0.4171497  0.7753319

To obtain a distance between the matrix columns (in case of a matrix
input) or the vector members (in case of a vector input) one has to
apply R’s dist() method. It can be called with different distance
measures like “euclidean”, “manhattan”,“maximum” and others (use ?dist()
to obtain a full list of available measurements). An example for how a
distance matrix is calculated from a 6\*6 matrix filled with random
values is depicted below.

``` r
#producing a 6*6 matrix with random values
matrix <- matrix(rnorm(36), nrow = 6)

#calculating a distance matrix
distance_matrix <- dist(matrix, method = "euclidean")
```

    #>          1        2        3        4        5
    #> 2 1.652463                                    
    #> 3 4.440832 3.852172                           
    #> 4 3.771591 3.007454 4.628683                  
    #> 5 5.065834 5.009443 5.274785 3.994050         
    #> 6 1.632503 2.042134 4.543818 4.244560 4.766897

### Hierarchical Clustering

[Hierachical
clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering) can
either be agglomerating (bottom-up) or divisive (top-down). Bottom-up
approaches start with all observations in one cluster and iteratively
group nearby clusters together until one large cluster is formed.
Top-down approaches start with all observations within one cluster and
separate this cluster subsequently into smaller clusters until every
observation is within its own cluster. Visualization is done by using a
dendrogram where straight lines depict distance between clusters and
horizontal lines group similar clusters together. To obtain such a
dendrogram it is crucial to determine the distance between the newly
formed clusters in every iteration step. Examples for such measures are
listed below. Please follow the links for information in more detail.

-   [Single
    linkage](https://en.wikipedia.org/wiki/Single-linkage_clustering)
    finds the minimum distance between points belonging to two different
    clusters
-   [Complete linkage](https://en.wikipedia.org/wiki/Complete_linkage)
    determines the maximum distance between points to two different
    clusters
-   [Average linkage (UPGMA)](https://en.wikipedia.org/wiki/UPGMA)
    calculates all pairwise distances of point in two different clusters
    and takes the average
-   [Average linkage (WPGMA)](https://en.wikipedia.org/wiki/WPGMA)
    similar to UPGMA but with weighted distances
-   [Centroid](https://en.wikipedia.org/wiki/Cluster_analysis#Centroid-based_clustering)
    finds the centroid of each cluster and determines distance between
    centroids of two different clusters
-   [Ward](https://en.wikipedia.org/wiki/Ward%27s_method) minimizes the
    overall distance

Given a distance matrix hierarchical clustering methods can be applied
via R’s hclust() function. Within hclust() the “method” parameter takes
a string object indicating the required clustering formula (“single”,
“complete”…). Printing an object produced by hclust() via the print()
function produces a dendrogram depicting the distances of all clusters.

``` r
#producing a 6*6 matrix with random values
matrix <- matrix(rnorm(36), nrow = 6)

#calculating a distance matrix
distance_matrix <- dist(matrix, method = "euclidean")

#applying hierarchical clustering
hc <- hclust(distance_matrix, method = "single")

#printing the clustering
print(hc)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Principal Component Analysis

A gene expression matrix provides a multidimensional space across
numerous features. It is not trivial presenting such data in a way that
we can easily comprehend it as we are only familiar with 2 dimensional
plotting. [Principal Component
Analysis](https://www.huber.embl.de/msmb/Chap-Multivariate.html) is a
way to reduce the dimension and plot the reduced data into 2 dimensional
space. To achieve this, observations are projected onto vectors
producing lines with respect to keeping the distances between points and
line low while covering as much variance as possible. This procedure
generates linear combinations of observation vectors called principal
components (PC). These (PC) are then plotted into a two dimensional
space. Usually, the two PC covering the largest variances are plotted as
they are likely to represent the most important features.

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub!
