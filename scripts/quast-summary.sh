#!/bin/bash

# Command line arguments
output_path="$3"

# Directory containing Polypolish output assemblies
quast_output_dir="$output_path/Results/quast"

# Output CSV file to store the summary data
output_csv_file="$output_path/Results/final_assembly_metrics.csv"

# Header for the CSV file
echo "Polypolish Output Folder,Number of Contigs,N50,GC Content (%)" > "$output_csv_file"

# Iterate over each QUAST output folder within the Polypolish output directory
for folder in "$quast_output_dir"/*; do
    if [ -d "$folder" ]; then
        quast_folder_name=$(basename "$folder")
        report_tsv="$folder/report.tsv"

        if [ -f "$report_tsv" ]; then
            num_contigs=$(awk -F'\t' '$1 == "# contigs (>= 0 bp)" {print $2}' "$report_tsv")
            n50=$(awk -F'\t' '$1 == "N50" {print $2}' "$report_tsv")
            gc_content=$(awk -F'\t' '$1 == "GC (%)" {print $2}' "$report_tsv")

            # Append to the CSV file
            echo "$quast_folder_name,$num_contigs,$n50,$gc_content" >> "$output_csv_file"
        fi
    fi
done

echo "Summary data saved to $output_csv_file"
