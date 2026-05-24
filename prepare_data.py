import pandas as pd
import os

df = pd.read_csv("results/all_results.csv")

os.makedirs("graphs/data", exist_ok=True)

metrics = ["PDR", "Throughput", "Delay", "Loss", "Overhead"]

# -------------------------
# Vary Nodes
# Fix Speed=10 Pause=20
# -------------------------
nodes_df = df[(df["Speed"] == 10) & (df["Pause"] == 20)]

for metric in metrics:
    pivot = nodes_df.pivot(index="Nodes", columns="Model", values=metric)
    pivot.to_csv(f"graphs/data/nodes_{metric.lower()}.dat")

# -------------------------
# Vary Speed
# Fix Nodes=30 Pause=20
# -------------------------
speed_df = df[(df["Nodes"] == 30) & (df["Pause"] == 20)]

for metric in metrics:
    pivot = speed_df.pivot(index="Speed", columns="Model", values=metric)
    pivot.to_csv(f"graphs/data/speed_{metric.lower()}.dat")

# -------------------------
# Vary Pause
# Fix Nodes=30 Speed=10
# -------------------------
pause_df = df[(df["Nodes"] == 30) & (df["Speed"] == 10)]

for metric in metrics:
    pivot = pause_df.pivot(index="Pause", columns="Model", values=metric)
    pivot.to_csv(f"graphs/data/pause_{metric.lower()}.dat")

print("Prepared graph datasets.")
