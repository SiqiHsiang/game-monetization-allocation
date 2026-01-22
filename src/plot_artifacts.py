import pandas as pd
import matplotlib.pyplot as plt

ev = pd.read_csv("artifacts/ev_curve.csv")
seg = pd.read_csv("artifacts/segment_breakdown.csv")

# EV curve
plt.figure()
plt.plot(ev["cumulative_cost"], ev["cumulative_ev"])
plt.xlabel("Cumulative Cost (Budget Used)")
plt.ylabel("Cumulative Expected Incremental Revenue")
plt.title("EV Curve: Budget vs Expected Incremental Revenue")
plt.tight_layout()
plt.savefig("artifacts/ev_curve.png", dpi=200)
plt.close()

# Segment breakdown (total_ev)
plt.figure()
plt.bar(seg["monetization_segment"], seg["total_ev"])
plt.xlabel("Monetization Segment")
plt.ylabel("Total Expected Incremental Revenue")
plt.title("Allocation Breakdown by Segment (Total EV)")
plt.tight_layout()
plt.savefig("artifacts/segment_total_ev.png", dpi=200)
plt.close()

print("Saved: artifacts/ev_curve.png, artifacts/segment_total_ev.png")