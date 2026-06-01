import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score  # Added for validation

# Define the file path
file_path = "data/output/dataset_for_unsupervised_ML.csv"

# Read the CSV file
df = pd.read_csv(file_path)

# Standardize the data 
scaler = StandardScaler()
df_scaled = scaler.fit_transform(df)

# Apply PCA with 13 components
pca = PCA(n_components=13)
pca_result = pca.fit_transform(df_scaled)

# Convert PCA result into a DataFrame
pca_df = pd.DataFrame(data=pca_result, columns=[f'PC{i+1}' for i in range(13)])

# Save the PCA-transformed data
pca_df.to_csv("data/output/pca_13_components.csv", index=False)

# Convert to NumPy array
X = pca_df.values

# Define a range of cluster numbers (k) to test
k_range = range(2, 11)
silhouette_scores = []

# Calculate silhouette score for each k using KMeans on the PCA-reduced space
for k in k_range:
    # Set n_init explicitly to suppress future warnings and ensure stable centroids
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = kmeans.fit_predict(X)
    score = silhouette_score(X, labels)
    silhouette_scores.append(score)

# Set up the plot
plt.figure(figsize=(10, 6))

# Plot silhouette scores against cluster counts
plt.plot(list(k_range), silhouette_scores, marker='o', color='teal', linewidth=2, markersize=8, label="Silhouette Score")

# Formatting with larger font sizes
plt.title("Silhouette Score vs. Number of Clusters (k)", fontsize=18)
plt.xlabel("Number of Clusters (k)", fontsize=16)
plt.ylabel("Average Silhouette Score", fontsize=16)

plt.xticks(list(k_range), fontsize=14)
plt.yticks(fontsize=14)

plt.grid(True, linestyle='--', alpha=0.6)
plt.legend(fontsize=12)
plt.tight_layout()

# Save figure
plt.savefig("data/output/Silhouette_Scores_KMeans.png",
            bbox_inches="tight", dpi=600)

plt.show()
