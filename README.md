#  **ONThybri-flow**
A simple pipeline for de novo genome assembly of bacterial isolates using ONT reads and Short-reads

## **Overview**
This pipeline integrates Nanopore and short-read sequencing data processing, offering a streamlined approach from assembly to quality assessment. It utilizes Flye for assembly, Medaka and Polypolish for error correction and polishing, and QUAST for assessing assembly quality.

## **Requirements**
- Flye, 
- Medaka, 
- Polypolish, 
- QUAST, 
- BWA and
- Samtools must be installed and accessible in the directory where you are executing the scripts.

## **Installation**

1)	Copy the git link from github page

``` git clone https://github.com/Vasundhara-Karthik/ONThybri-flow.git ```

## **Usage**

Execute the pipeline with:

``` ./master_script.sh <nanopore_fastq_dir> <short_reads_dir> <output_path> <threads> <scripts_path> ```

Parameters include directories for Nanopore FASTQ and short-read data, the output path, the number of processing threads, and the path to scripts.

## **Scripts overview**

1.	flye.sh: Assembles genomes using Flye.
2.	medaka.sh: Applies Medaka for ONT-based error correction.
3.	polypolish.sh: Further polishes assemblies using short-read with Polypolish.
4.	quast.sh: Assesses assembly quality with QUAST.
5.	quast-summary.sh: Summarizes QUAST metrics in a CSV file.
6.	Ensure these scripts are executable (`chmod +x` “script_name”).
   
## **Output description**

Outputs are organized into directories corresponding to each process step:

1.	Flye (Path: output_path/Results/flye): Contains ‘assembly.fasta’ files from the Flye assembler.
2.	Medaka (Path: output_path/Results/medaka): Stores error-corrected assemblies from Medaka.
3.	Polypolish sequences (Path: output_path/Results/polypolish): Holds final polished genome.
4.	QUAST (Path: output_path/Results/quast): Includes detailed assembly quality reports.
5.	QUAST Summary: Features a `final_assembly_metrics.csv` file summarizing key QUAST metrics.
   
This structured output facilitates easy access to detailed assembly data and quality metrics.
