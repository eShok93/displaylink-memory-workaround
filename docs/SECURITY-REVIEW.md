# Scoped security and publication review

Review date: October 28, 2026. Scope: this repository's shell script, tests, documentation, issue template, and published image. This is a focused source/privacy review, not an independent penetration test, vendor-code audit, certification, or guarantee.

## Result

No confirmed security vulnerability was identified in this bounded review. The only privileged action is a fixed invocation of Apple's `launchctl` for one DisplayLink helper. Reset is explicit and interactive. Residual operational risk: a brief display interruption, recurrence of the vendor leak, and possible failure of the helper to recover. The script cannot guarantee UI performance improvement.

## Source checks

| Surface | Boundary / check | Result |
| --- | --- | --- |
| CLI input | Fixed action allowlist; extra arguments rejected | No caller-selected command, PID, service or path reaches privilege escalation |
| Privilege | Only a fixed absolute-path `sudo launchctl` command | No root script execution required, no shell evaluation of user input |
| Cancellation | `read` failure or any response other than literal `RESET` exits before sudo | Reviewed in source; not dynamically exercised against the live service |
| Tool lookup | Absolute paths for diagnostic and privileged tools; constrained PATH | No repository-local binary lookup for the privileged action |
| Output | `top` filtered to its header and the selected helper PID | Unrelated process output and system-wide summary suppressed |
| Persistence / egress | Source inspected for writes, scheduled actions, network or telemetry | None in the workaround script |
| Publication | Explicit file staging, text review, identifier/credential pattern scan | No raw logs or diagnostic archives included |
| Image | Visually inspected and PNG chunks checked | No desktop capture, text metadata or EXIF; only transcribed allowlisted measurements |
| Attribution | Claims checked against measured output and cited vendor material | Workaround and uncertainty clearly distinguished from source-level fix |

## Validation actually performed

- Bash syntax validation passed.
- Smoke checks passed for help, unknown action, excess arguments, and non-macOS refusal of both diagnosis and reset.
- Those execution checks ran in an existing local `php:8.3-cli` container with no network, a read-only repository and root filesystem, all capabilities dropped, no new privileges, 128 MiB memory/swap ceiling, 0.5 CPU, 32-PID limit, CPU/file-size limits and an 8 MiB scratch tmpfs. No dependencies were fetched.
- The original fixed service command was manually executed and verified on the reported macOS configuration before packaging this script. The packaged script's complete privileged reset path was **not** executed against the live Mac during this review; no additional reset was needed to validate publication.
- A first attempt at native macOS sandboxed smoke checks stopped before script execution because the requested address-space resource limit could not be applied. Container checks replaced that attempt; they do not establish macOS integration coverage.
- Relative documentation/image links, whitespace and public-file privacy patterns were checked before publication. Pattern scans supplement human review; they cannot prove absence of every possible secret.

## Remaining limits

Only the observed OS/app configuration has a manually verified service-reset result. The exact helper source is unavailable to this project. Race conditions in process startup can make immediate diagnostic verification fail after an otherwise successful restart; the tool asks the user to retry diagnosis rather than silently resetting again. Long-term recurrence and other software versions are not validated here.

A malicious local checkout, already-compromised OS, shell startup files or an administrator can subvert local execution; those are outside this project's boundary. Review the checkout and never grant it passwordless root access.

## Re-run smoke checks

```bash
bash tests/check.sh
```

The checks never invoke reset on macOS. They are functional smoke checks, not a replacement for the source review or an end-to-end driver test.
