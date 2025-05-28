import sys
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

if len(sys.argv) < 2:
    print("Usage: python boxplot.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

# Load CSV
df = pd.read_csv(filename)

# Set Seaborn style
sns.set(style="whitegrid")

# Get list of unique operations
operations = df['Operation'].unique()

fig, axes = plt.subplots(1, 2, figsize=(6, 4), sharey=True)  # 1 row, 2 columns

# Plot histograms for each operation
i = 0
for op in operations:
    subset = df[df['Operation'] == op]

    g = sns.boxplot(
        data=subset, y="time", hue="Transaction mode", ax=axes[i], hue_order=['Read-only', 'Read-write'],
    )
    axes[i].set_title(f"{op}")
    i += 1

axes[0].set_ylabel("time [ms]")
plt.tight_layout()
plt.show()
