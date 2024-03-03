#!/bin/bash

# Ensure Polypolish and Samtools are installed
if ! command -v polypolish &> /dev/null; then
    echo "Polypolish could not be found. Please install Polypolish to continue."
    exit 1
fi

if ! command -v samtools &> /dev/null; then
    echo "Samtools could not be found. Please install Samtools to continue."
    exit 1
fi

# Command line arguments
output_path="$3"
short_read_dir="$2"
threads="$4"

# Directories
medaka_output_dir="$output_path/Results/medaka"
polypolish_output_dir="$output_path/Results/polypolish"
aln_dir="$output_path/tmp"

# Create directories if they don't exist
mkdir -p "$polypolish_output_dir"
mkdir -p "$aln_dir"

# Process each Medaka output
for medaka_output in "$medaka_output_dir"/*; do
    if [ -d "$medaka_output" ]; then
        assembly_name=$(basename "$medaka_output")
        
        # Set the input paths
        medaka_assembly="$medaka_output/consensus.fasta"
        IL1="$short_read_dir/${assembly_name}_R1.trimmed.fastq.gz"
        IL2="$short_read_dir/${assembly_name}_R2.trimmed.fastq.gz"
        
        # Build bwa index
        bwa index $medaka_assembly

        # Build alignment mapping files
        bwa mem -t $threads -a $medaka_assembly $IL1 > "$aln_dir/${assembly_name}_1.sam"
        bwa mem -t $threads -a $medaka_assembly $IL2 > "$aln_dir/${assembly_name}_2.sam"
 
        # Filter the alignments
        polypolish_insert_filter.py --in1 "$aln_dir/${assembly_name}_1.sam" --in2 "$aln_dir/${assembly_name}_2.sam" --out1 "$aln_dir/${assembly_name}_filtered_1.sam" --out2 "$aln_dir/${assembly_name}_filtered_2.sam"
        
        # Polish the assembly with short-reads
        polypolish $medaka_assembly "$aln_dir/${assembly_name}_filtered_1.sam" "$aln_dir/${assembly_name}_filtered_2.sam" > "$polypolish_output_dir/${assembly_name}_pol.fasta"
        
        echo "Corrected assembly for $assembly_name is done."
    fi
done

echo "All assemblies corrected successfully."
