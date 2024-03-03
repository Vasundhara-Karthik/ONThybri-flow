#!/bin/bash

# Display help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0 <nanopore_fastq_dir> <short_reads_dir> <output_path> <threads> <scripts_path>"
  echo "Arguments:"
  echo "  nanopore_fastq_dir - Directory containing Nanopore FASTQ files."
  echo "  short_reads_dir    - Directory containing short-read data."
  echo "  output_path        - Output path for all results."
  echo "  threads            - Number of threads to use."
  echo "  scripts_path       - Path to the directory containing all scripts (flye.sh, medaka.sh, polypolish.sh, quast.sh, quast-summary.sh)."
  exit 0
fi

# Ensure correct number of arguments
if [ "$#" -ne 5 ]; then
  echo "Error: Incorrect number of arguments."
  echo "For help, run: $0 --help"
  exit 1
fi

# Command line arguments
nanopore_fastq_dir="$1"
short_reads_dir="$2"
output_path="$3"
threads="$4"
scripts_path="$5"

# Step 1: Run Flye assembly
echo "Starting Flye assembly..."
bash "$scripts_path/flye.sh" "$nanopore_fastq_dir" "$output_path" "$threads"
echo "Flye assembly completed."

# Step 2: Run Medaka for error correction
echo "Starting Medaka error correction..."
bash "$scripts_path/medaka.sh" "$output_path" "$nanopore_fastq_dir" "$threads"
echo "Medaka error correction completed."

# Step 3: Run Polypolish for further polishing
echo "Starting Polypolish..."
bash "$scripts_path/polypolish.sh" "$output_path" "$short_reads_dir" "$threads"
echo "Polypolish completed."

# Step 4: Run QUAST for assembly evaluation
echo "Starting QUAST evaluation..."
bash "$scripts_path/quast.sh" "$output_path" "$threads"
echo "QUAST evaluation completed."

# Step 5: Generate QUAST summary report
echo "Generating QUAST summary report..."
bash "$scripts_path/quast-summary.sh" "$output_path"
echo "QUAST summary report generated."

echo "Pipeline execution completed."
