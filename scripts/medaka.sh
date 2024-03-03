#!/bin/bash

# Check if Medaka is installed
if ! command -v medaka_consensus &> /dev/null
then
    echo "Medaka could not be found. Please install Medaka to continue."
    exit 1
fi

# The first command line argument is the output path from the previous Flye assembly
output_path="$3"
# The second command line argument is the path to input ONT fastq files
fastq_dir="$1"
# The third command line argument is the number of threads
threads="$4"

# Set the directory containing Flye assemblies
assembly_dir="$output_path/Results/flye"

# Set the output directory for Medaka-corrected assemblies within the provided output path
medaka_output_dir="$output_path/Results/medaka"

# Create the Medaka output directory if it does not exist
mkdir -p "$medaka_output_dir"

# Loop through each Flye assembly directory
for assembly in "$assembly_dir"/*; do
    if [ -d "$assembly" ]; then
        # Extract the assembly name
        assembly_name=$(basename "$assembly")
        
        # Set the paths for input fastq and the assembly fasta
        input_fastq="$fastq_dir/$assembly_name.fastq"
        input_fasta="$assembly/assembly.fasta"
        output_corrected="$medaka_output_dir/${assembly_name}_corrected"
        
        # Run Medaka correction
        medaka_consensus -i "$input_fastq" -d "$input_fasta" -o "$output_corrected" -t "$threads"
        
        echo "Correction completed for $assembly_name."
    fi
done

echo "All assemblies corrected successfully."
