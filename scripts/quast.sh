#!/bin/bash

# Ensure QUAST is installed
if ! command -v quast.py &> /dev/null; then
    echo "QUAST could not be found. Please install QUAST to continue."
    exit 1
fi

# Command line arguments
output_path="$3"

# Directory containing Polypolish output assemblies
polypolish_assemblies_dir="$output_path/Results/polypolish"
output_dir="$output_path/Results/quast"

# Create the output directory for QUAST reports if it doesn't exist
mkdir -p "$output_dir"

# Run QUAST for each Polypolish assembly
for assembly in "$polypolish_assemblies_dir"/*.fasta; do
    assembly_name=$(basename "$assembly" .fasta)
    quast_report_dir="$output_dir/$assembly_name"
    
    # Run QUAST
    quast -o "$quast_report_dir" -m 300 -t 4 "$assembly"
    echo "QUAST report generated for $assembly_name."
done

echo "QUAST analysis completed for all assemblies."
