import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans

# Number of clusters (optimum number of clusters from eigengap analysis)
n_clusters = 4

#input file 
file_path = "E:/Research/Mobility/Datasets/a2/pca_13_components.csv"
pca_df = pd.read_csv(file_path)

# Apply K-means clustering
kmeans = KMeans(n_clusters=n_clusters, random_state=42)  # Set random_state for reproducibility
X = pca_df.values
kmeans.fit(X)

# Get cluster labels
labels = kmeans.labels_

# Add cluster labels to the DataFrame (optional)
pca_df['cluster'] = labels

# Print cluster assignments (optional)
#print("Cluster Assignments:")
#print(pca_df[['cluster']].head())  # Print the first few cluster assignments

# Visualize the clusters (Using the first three principal components)
if X.shape[1] >= 2:
    # 3D plot
    fig_3d = plt.figure(figsize=(10, 8))  # Increase figure size
    ax_3d = fig_3d.add_subplot(111, projection='3d')
    ax_3d.scatter(X[:, 0], X[:, 1], X[:, 2], c=labels, cmap='viridis')
    ax_3d.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], kmeans.cluster_centers_[:, 2], s=300, c='red', marker='*', label='Centroids')
    ax_3d.set_title("3D Visualization (PC1, PC2, PC3)")
    ax_3d.set_xlabel("Principal Component 1")
    ax_3d.set_ylabel("Principal Component 2")
    ax_3d.set_zlabel("Principal Component 3", labelpad=15)  # Add labelpad for better visibility

    # Adjust viewing angle
    ax_3d.view_init(elev=20, azim=-50)  # Adjust elevation and azimuth

    ax_3d.legend()
    plt.show()

else:
    print("Cannot visualize clusters directly (data is not 2D or 3D).")