---
name: bambu-account
description: Switch, save, list, or log out Bambu Lab accounts in Bambu Studio on macOS with the bambu-account CLI. Use when the user wants to change which Bambu Lab account Bambu Studio is logged in to, back up a login, log out when the in-app Log out button does nothing, or when Bambu Studio can't see a printer because it is logged in to the wrong account.
---

# bambu-account

Bambu Studio stores its login in one encrypted token file,
`~/Library/Application Support/BambuStudio/BambuNetworkEngine.conf`.
`bambu-account` saves that file per account under `~/.bambu-accounts/<name>/`
and swaps it back in. macOS only.

## Install

Check with `command -v bambu-account` (or `~/.local/bin/bambu-account`).
If missing, install it into the user's home; no sudo needed:

```sh
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/Jacky97s/bambu-account/main/bambu-account -o ~/.local/bin/bambu-account
chmod +x ~/.local/bin/bambu-account
```

If `~/.local/bin` isn't on `PATH`, call it by full path and tell the user.

## Commands

| Command | Does | Needs Studio closed |
| --- | --- | --- |
| `bambu-account list` | List saved accounts | no |
| `bambu-account save <name>` | Back up the current login as `<name>` | no |
| `bambu-account use <name>` | Switch to `<name>`; current login saved as `_last` | yes |
| `bambu-account logout` | Log out; current login saved as `_last` | yes |

`bambu-account use _last` undoes the last switch.

## Workflow

1. Run `bambu-account list` to see which accounts exist.
2. For `use` or `logout`, check `pgrep -x BambuStudio`. If it is running,
   ask the user to quit it with Cmd+Q. Don't kill it yourself: they may
   have an unsaved project.
3. Run the command, then tell the user to open Bambu Studio.
4. To add an account: `save` the current one if it isn't saved yet, then
   `logout`, have the user open Studio and log in, quit it, and
   `save <new name>`.

## Rules

- The saved files are login tokens. Never print, read, upload, or commit
  them, and never ask the user for a password or printer access code.
- Ask before overwriting an existing saved name with `save`.
- If Studio asks to log in again after `use`, the token expired: have the
  user log in, then `save <name>` again.
- Only the login switches. Region, last printer, LAN access codes and presets
  in `BambuStudio.conf` stay shared.
- Bambu Connect keeps its own login; this tool doesn't change it.
