# Evidence and limits

## Observed on October 28, 2026

Only a minimal technical summary is retained publicly. Raw system output and diagnostic archives are deliberately excluded.

| Item | Observation |
| --- | --- |
| OS | macOS 27.0.1 |
| Application | DisplayLink Manager 17.0.24 |
| Hardware class | Apple Silicon Mac, 24 GB RAM |
| Helper elapsed time before reset | About 26 days |
| Before, `top MEM / CMPRS` | `6498M / 6491M` |
| After, `top MEM / CMPRS` | `3744K / 880K` |
| Intervention | Fixed `launchctl kickstart -k` on the DisplayLink system helper |
| Verification | New helper PID, service running, fresh `top` sample |

A same-day macOS memory event identified `DisplayLinkPrivilegedHelper` as its largest process. Raw logs are not published because they include unrelated system details.

## What this establishes

The accumulated helper allocation was reclaimable through a service restart without rebooting macOS. The version and symptom match a manufacturer-acknowledged issue. This is a single-machine before/after observation, not a controlled performance benchmark, independent heap analysis, proof of the exact allocation site, or measurement of a long-term growth rate.

A privileged `vmmap` analysis was not obtained. Do not attribute the cause to a specific watchdog, API, object-retention bug, or source line on the strength of these measurements.

System-wide memory pressure remained elevated after the reset. Other applications and a virtual machine also consumed memory. We did not measure a before/after change in UI latency, FPS, or throughput. We do not claim the reset solved all sluggishness.

## Reproduce responsibly

1. Use the system normally; do not deliberately exhaust memory.
2. Run `diagnose` if the helper's allocation appears excessive.
3. Note elapsed time locally, the app version, and `MEM`/`CMPRS`.
4. If appropriate, run the manual reset and collect another diagnosis.
5. Observe memory again over subsequent days. Repeated growth after reset supports recurrence; it does not identify the internal source defect.

## Screenshot provenance

`assets/measured-result.png` is a real screenshot of a purpose-built local HTML evidence summary (`assets/measured-result.html`). Its values were transcribed from the measurements above. It is explicitly labelled as a rendered summary. It contains no desktop capture, original prompt, hostname, user path, IP address, raw report, process list, or device identifier. The screenshot is illustrative evidence presentation, not an independently collected measurement.

## Sources

- [Version-specific report and manufacturer acknowledgement](https://www.displaylink.org/forum/showthread.php?p=99661).
- [Official macOS downloads](https://www.synaptics.com/products/displaylink-graphics/downloads/macos).
- [Official support collection and reporting instructions](https://support.displaylink.com/knowledgebase/articles/755301).
- [Manufacturer's published open-source component overview](https://www.synaptics.com/products/displaylink-graphics/embedded/sdk). No public source repository for the affected macOS helper was found during research; this is not a claim that all DisplayLink code is closed.
