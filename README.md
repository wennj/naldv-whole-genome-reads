# Identifying Nanopore reads that span entire genomes of nuclear arthropod-specific large DNA viruses

The figures and content in this repository are derived from the following publication:

**Wennmann, J.T. (submitted). Nanopore reads spanning the whole genome of arthropod-infecting large dsDNA viruses of the class Naldaviricetes enable assembly-free sequence analysis. [DOI link to the publication]**

## Aim of this repository

-   Present and explain the code used to create the figures in the manuscript (Wennmann, 2024).

-   Particular attention is paid to the detection of reads that may comprise entire genomes of NALDVs and represent individual viral genomes.

-   Learn how to approach Nanopore sequence data sets of NALDVs. It demonstrates the importance of carefully examining the data to avoid subsequent errors in the analysis.

## Importance of Nanopore sequencing for NALDV genomes

Nanopore sequencing is becoming increasingly popular for sequencing the genomes of nuclear arthropod-specific large DNA viruses (NALDV). In particular, in combination with Illumina sequencing, it provides a highly accurate method for error-free decoding of large repetitive sequence regions. As of July 2024, hundreds of genomes in the Naldaviricetes class have been published in the NCBI Genbank. These are consensus sequences based on assemblies. Nanopore sequencing makes it possible for the first time to sequence significantly large fragments of NALDV genomes. It is even conceivable that entire genomes could be sequenced in single reads, enabling assembly-free analysis of NALDV genomes.

## Consensus genomes published on NCBI Genbank

To get an overview of the number of published NALDV genomes (as of July 2024), all NCBI Genbank entries found under the individual names of the virus families (Baculoviridae, Nudiviridae, Nimaviridae, Hytrosaviridae) are available in the directory /data/xml. A filter has been set to only allow sequences in the range of complete genomes. The list is probably not complete, but it is a good approximation of all genomes that are publicly available at this time.

The XML files are first read into R and converted into a data frame. The virus name (isolate, strain), accession number, genome length and publication date are extracted. As soon as the data has been imported, the image can be created from it using ggplot2 [(](https://github.com/wennj/naldv-whole-genome-reads/blob/main/output/NALDV_stats_on_Genbank_SRA.png)[Figure](output/NALDV_stats_on_Genbank_SRA.png)[1A)](https://github.com/wennj/naldv-whole-genome-reads/blob/main/output/NALDV_stats_on_Genbank_SRA.png).

[Click here for the R code used to create the figure.](output/NCBI_statistics.Rmd)

## Sequence data available from NCBI SRA

Analysing the availability of Illumina and Nanopore data sets on NCBI SRA is a bit easier. You can search and filter for the datasets on NCBI. All hits can be downloaded directly as a CSV files. These files then serve as input for the subsequent analysis. The result is a plot showing the time course of the published SRA data sets (Illumina and Nanopore) as of July 2024 [(Figure 1B)](output/NALDV_stats_on_Genbank_SRA.png).

[Click here for the R code used to create the figure.](NCBI_statistics.Rmd)

![](output/ncbi_stats/NALDV_stats_on_Genbank_SRA.png)

## Quality of sequencing techniques

‘Sequencing by synthesis’ and Nanopore sequencing are based on completely different methods. While Illumina sequencing (sequencing by synthesis) generates short reads that are extremely accurate, the probability of error is much higher for the long reads of Nanopore sequencing. The following graphic was created to illustrate this. The X-axis shows the Phred quality score (Q), which was converted into the error probability (Y-axis): $$
P = 10^{-\frac{Q}{10}}
$$ The values of selected raw sequencing data, which is available on NCBI SRA, were visualized by this plot. The vertical and horizontal dashed lines connect Q = 20 with the corresponding P = 1%.

[Click here for the R code used to create the figure.](https://github.com/wennj/naldv-whole-genome-reads/blob/main/quality_score_visualization.R)

![](output/ncbi_stats/phred_vs_probability_combined.png)

## Read length distribution

To determine the length of Nanopore reads from a sequencing run, it is best to create a distribution of sequenced DNA fragments. In the present example, three data sets of BmNPV-Th2 (family Baculoviridae), OrNV-DUG42 (family Nudiviridae) and WSSV-JP04 (family Nimaviridae) were analysed with regard to their length distribution.:

| Name       | NCBI SRA Number | Reference                                    |
|---------------|----------------|------------------------------------------|
| BmNPV-Th2  | SRR27030578     | <https://doi.org/10.1016/j.jip.2024.108221>  |
| OrNV-DUG42 | SRR21977634     | <https://doi.org/10.1128/mra.00126-23>       |
| WSSV-JP04  | DRR420912       | <https://doi.org/10.1007/s12562-023-01715-4> |

[Click here for the R code used to create the figure.](https://github.com/wennj/naldv-whole-genome-reads/blob/main/2_length_quality_statistics.Rmd)

![](output/read_length_distribution/length_distribution_combined.png)

## Read quality distribution

One of the most important quality characteristics of Nanopore sequencing is its quality. If the quality is calculated individually for each read, the quality of the entire sequencing runcan be represented as a distribution. This was done for the NCBI SRA data sets of (A) BmNPV-Th2, (B) OrNV-DUG42 and (C) WSSV-JP04.

[Click here for the R code used to create the figure.](https://github.com/wennj/naldv-whole-genome-reads/blob/main/2_length_quality_statistics.Rmd)

![](output/read_quality_distribution/read_quality_distribution_combined.png)

## Read length and quality comparison

The length of the reads can also be compared with their quality, which allows to test for a possible correlation. It provides information on whether certain reads possibly cover the entire genome of the viruses in terms of length and whether they are of sufficient quality. The dashed lines indicate the average read quality (horizontal line) and half the length of the virus genome (vertical line). The vertical dotted line indicates the full length of the virus genome (A = BmNPV-Th2, B = OrNV-DUG42, C = WSSV-JP04).

[Click here for the R code used to create the figure.](https://github.com/wennj/naldv-whole-genome-reads/blob/main/2_length_quality_statistics.Rmd)

![](output/read_length_vs_quality/read_length_vs_quality_combined.png)
