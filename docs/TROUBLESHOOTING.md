# Troubleshooting

**Helper not registered/running:** Check that DisplayLink Manager is installed and enabled. This tool expects `/Applications/DisplayLink Manager.app` and the known system service label. It does not install, enable, or repair DisplayLink. Alternate installations are unverified.

**Permission denied:** Reset uses Apple's `sudo` to restart a system service. Use an authorized administrator account and enter credentials only at the local system prompt. Do not disable protections, run the whole repository as root, or add passwordless sudo rules.

**Service restarted but verification failed:** The new process may take time to appear. Wait briefly and run `diagnose` again. A verification error does not roll back a successful restart. If the service fails to recover, open DisplayLink Manager and consult vendor support.

**Displays blink:** A brief interruption can occur during the manual reset. Do it between screen sharing, recording, presentations, or other display-sensitive tasks.

**Memory grows again:** Expected for a workaround that leaves the faulty software installed. Track recurrence and check official release notes. No automatic reset is installed.

**Mac still slow:** The helper can be only one contributor. Check current memory pressure and per-process activity. A large historical swap allocation does not mean the SSD is currently thrashing. This project does not diagnose network, Docker, disk hardware, or unrelated CPU problems.

**Remove the workaround:** Delete this repository's directory. No launch agents, schedules, configuration files, or background processes are installed.
