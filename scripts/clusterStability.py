import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import adjusted_rand_score
from sklearn.utils import resample

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

# Create the output directory if it doesn't exist
import os
os.makedirs('data/output', exist_ok=True)

# Save the PCA-transformed data
pca_df.to_csv("data/output/pca_13_components.csv", index=False)

# Convert to NumPy array
X = pca_df.values

# For the sake of this stability test, we fix k=4 based on your text's "four archetypes"
OPTIMAL_K = 4
N_BOOTSTRAP = 1000
random_state = 42

# --- 2. Establish baseline clustering on the full dataset ---
baseline_kmeans = KMeans(n_clusters=OPTIMAL_K, random_state=random_state, n_init=10)
baseline_labels = baseline_kmeans.fit_predict(X)

# --- 3. Bootstrap Resampling Loop ---
ari_scores = []
n_samples = X.shape[0]

print(f"Running {N_BOOTSTRAP} bootstrap iterations for k={OPTIMAL_K}...")

for i in range(N_BOOTSTRAP):
    # Sample indices with replacement
    bootstrap_indices = resample(np.arange(n_samples), replace=True, random_state=random_state + i)
    X_bootstrap = X[bootstrap_indices]

    # Fit KMeans on the bootstrap sample
    boot_kmeans = KMeans(n_clusters=OPTIMAL_K, random_state=random_state + i, n_init=10)
    boot_labels = boot_kmeans.fit_predict(X_bootstrap)

    # Predict clusters for the ENTIRE baseline dataset using the bootstrap-trained model
    # This allows a direct 1:1 comparison back to our baseline labels
    predicted_labels_on_full = boot_kmeans.predict(X)

    # Calculate Adjusted Rand Index (ARI) against the baseline
    ari = adjusted_rand_score(baseline_labels, predicted_labels_on_full)
    ari_scores.append(ari)

print("Bootstrap validation complete.")

# --- 4. Plot and Save the Stability Results ---
plt.figure(figsize=(8, 5))

# Plotting a histogram/KDE of ARI scores
plt.hist(ari_scores, bins=15, color='darkslateblue', edgecolor='black', alpha=0.7, label='Bootstrap Replicates')

# Add mean and median lines for journal presentation
mean_ari = np.mean(ari_scores)
median_ari = np.median(ari_scores)
plt.axvline(mean_ari, color='crimson', linestyle='--', linewidth=2, label=f'Mean ARI: {mean_ari:.2f}')
plt.axvline(median_ari, color='darkorange', linestyle=':', linewidth=2, label=f'Median ARI: {median_ari:.2f}')

# Formatting for npj standards
plt.title(f"Cluster Stability Distribution (k={OPTIMAL_K})", fontsize=16, fontweight='bold')
plt.xlabel("Adjusted Rand Index (ARI)", fontsize=14)
plt.ylabel("Frequency", fontsize=14)
plt.xlim(0, 1.05)  # ARI ranges from -1 to 1, but stability should ideally be > 0.6
plt.grid(True, linestyle='--', alpha=0.5)
plt.legend(fontsize=11, loc='upper left')
plt.tight_layout()

# Save the figure
plt.savefig("data/output/Cluster_Stability_ARI.png", bbox_inches="tight", dpi=600)
plt.show()

# --- 5. Summary Statistics for your Manuscript text ---
print("\n--- Manuscript Statistics ---")
print(f"Mean ARI: {mean_ari:.4f}")
print(f"Median ARI: {median_ari:.4f}")




