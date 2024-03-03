#!/bin/bash

# Check if Flye is installed
if ! command -v flye &> /dev/null
then
    echo "Flye could not be found. Please install Flye to continue."
    exit 1
fi

# Use the first command line argument as the input directory
input_dir="$1"
# The second command line argument is the output path
output_path="$3"
# The third command line argument is the number of threads
threads="$4"

# Set the output directory to "Results/flye" within the provided output path
output_dir="$output_path/Results/flye"

# Create the output directory if it does not exist
mkdir -p "$output_dir"

# Loop through all the fastq files in the input directory
for file in "$input_dir"/*.fastq; do
    # Extract the base filename without the path and extension
    base=$(basename "$file" .fastq)

    # Define the output directory for this assembly
    assembly_output_dir="$output_dir/$base"

    # Run the assembly using Flye
    flye --nano-raw "$file" --out-dir "$assembly_output_dir" --threads "$threads"

    echo "Assembly complete for $base"
done

echo "All files assembled successfully."
