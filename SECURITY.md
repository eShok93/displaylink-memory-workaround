# Security policy

This repository contains an unofficial manual workaround, not a security product or a vendor-supported driver patch.

## Trust boundary

- Diagnosis is read-only and runs as the current user.
- Reset requires a literal `RESET` confirmation, then invokes `/usr/bin/sudo` with a fixed `/bin/launchctl` executable, verb, and service label.
- No caller input is interpolated into the privileged command. The script accepts only one fixed subcommand and uses absolute tool paths.
- No network requests, telemetry, credential storage, downloads, file deletion, persistence, or security-setting changes occur in the script.
- Review downloaded code before running it. Do not run the entire script as root, grant it passwordless sudo, or install automatic restarts.
- This does not defend against an already compromised macOS installation, a malicious shell startup environment, an altered local checkout, or a malicious administrator.

## Reporting

For a security issue in this repository, use the repository's GitHub private vulnerability reporting feature if available. Otherwise ask the maintainer for a private reporting channel without publishing exploit details or secrets. No private channel is guaranteed to be configured at initial publication. Ordinary workaround bugs can use a public issue with sanitized data.

DisplayLink's own driver defects belong with Synaptics/DisplayLink support. Do not attach raw support archives to public GitHub issues.

The included [review](docs/SECURITY-REVIEW.md) is a bounded source and privacy review, not a certification or full audit of DisplayLink or macOS.
