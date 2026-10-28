# Manufacturer report draft — not submitted

**Suggested destination:** the existing [version-specific forum thread](https://www.displaylink.org/forum/showthread.php?p=99661), or private vendor support following the [official reporting procedure](https://support.displaylink.com/knowledgebase/articles/755301).

**Subject:** Additional observation: DisplayLinkPrivilegedHelper memory accumulation on 17.0.24 / macOS 27.0.1

I observed substantial memory accumulation in DisplayLinkPrivilegedHelper on an Apple Silicon Mac with 24 GB RAM, running macOS 27.0.1 and DisplayLink Manager 17.0.24.

After approximately 26 days of helper uptime, `top` reported `MEM 6498M` and `CMPRS 6491M`. A same-day macOS memory event also named the helper as its largest process.

Restarting only `system/com.displaylink.DisplayLinkManager.PrivilegedHelper` with `launchctl kickstart -k` reduced the helper's next measured allocation to `MEM 3744K` and `CMPRS 880K`. A new helper PID was running; the Mac was not rebooted.

This matches the symptoms acknowledged earlier in this thread. I have not collected privileged heap analysis or established a source-level cause. System-wide memory pressure remained elevated, so I am not claiming that this resolved every performance issue.

Could you confirm which release fixes this issue, and whether this targeted helper restart is a supported temporary mitigation?

The accompanying public summary contains only allowlisted technical measurements. No full diagnostic bundle, identifying device data, or unrelated process output is attached. Additional diagnostics can be reviewed before sharing privately through the official support channel.
