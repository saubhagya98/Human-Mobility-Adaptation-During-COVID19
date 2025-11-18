import pandas as pd

def process_csv_data(input_file, output_file):
    # Load the Excel file
    df = pd.read_csv(input_file)    
    
    # Extract column names
    column_names = df.columns
    
    # Initialize an empty DataFrame to store results
    result_df = pd.DataFrame()
    
    # Process every 4 columns
    for i in range(0, len(column_names), 4):
        if i + 3 < len(column_names):
            # Extract relevant columns
            col1, col2, col3, col4 = column_names[i:i+4]
            
            # Compute the value based on the given formula
            result_column_name = col1  # Use the first column's name
            result_df[result_column_name] = df[col1] - (df[col2] + df[col3] + df[col4]) / 3
    
    # Save the results to a new Excel file
    result_df.to_csv(output_file, index=False)
    print(f"Results saved to {output_file}")

# Example usage
input_file = "data/input/dataset_without_demographics.csv"  # Replace with your actual file path
output_file = "data/output/dataset_for_unsupervised_ML.csv"  # Output file name

process_csv_data(input_file, output_file)
