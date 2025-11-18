import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from scipy.linalg import eigh
from scipy.spatial.distance import cdist
from sklearn.cluster import KMeans

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

#Save the PCA-transformed data
pca_df.to_csv("data/output/pca_13_components.csv", index=False)

# Convert to NumPy array
X = pca_df.values

# Define a range of sigma values to explore
sigma_values = np.linspace(1, 2.71828, 100)

log_sigma_values = np.log(sigma_values)
all_eigengaps = []

# Compute eigengaps for each sigma
for sigma in sigma_values:
    distance_matrix = cdist(X, X, metric='sqeuclidean')
    A = np.exp(-distance_matrix / (2 * sigma ** 2))
    np.fill_diagonal(A, 0)
    D = np.diag(np.sum(A, axis=1))
    D_inv_sqrt = np.linalg.inv(np.sqrt(D))
    L = np.eye(A.shape[0]) - D_inv_sqrt @ A @ D_inv_sqrt
    eigenvalues, _ = eigh(L)
    eigenvalues = np.sort(eigenvalues)
    eigengaps = np.diff(eigenvalues)
    all_eigengaps.append(eigengaps)

plt.figure(figsize=(10, 6))

# Plot all eigengaps using the default color cycle
lines = []
for i in range(min(10, all_eigengaps[0].shape[0])):
    eigengap_values = [eigengaps[i] for eigengaps in all_eigengaps]
    line, = plt.plot(log_sigma_values, eigengap_values, linewidth=1.8, label=f"Eigengap {i+1}")
    lines.append(line)

# Highlight the 4th eigengap (index 3)
highlight_index = 3
highlight_values = [eigengaps[highlight_index] for eigengaps in all_eigengaps]
base_color = lines[highlight_index].get_color()
plt.plot(log_sigma_values, highlight_values, color=base_color, linewidth=2.5)
plt.plot(log_sigma_values, highlight_values, color='gold', linewidth=10, alpha=0.8, label="Highlighted 4th Eigengap (k=4)")

# Formatting
plt.title("Eigengap vs. log(sigma)")
plt.xlabel("log(sigma)")
plt.ylabel("Eigengap")
plt.grid(True, linestyle='--', alpha=0.6)
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', fontsize=9)
plt.tight_layout()


# Save figure
plt.savefig("data/output/eigengap_curve.png",
            bbox_inches="tight", dpi=600)

plt.show()

