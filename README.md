# bambu-account

Quickly switch between multiple Bambu Lab accounts in **Bambu Studio** on macOS.

Bambu Studio keeps its login in one encrypted token file,
`~/Library/Application Support/BambuStudio/BambuNetworkEngine.conf`.
`bambu-account` backs that file up per account and swaps it in, so switching
accounts takes one command instead of logging out and in again. It also works
when the in-app **Log out** button does nothing.

> [!WARNING]
> **macOS only.** Windows and Linux are not supported or tested, and the
> script exits with an error there. Contributions are welcome, see
> [Contributing](#contributing).

## AI agent skill

Install the skill into your AI coding agent (Claude Code, Cursor, Codex and
others) with [skills](https://github.com/vercel-labs/skills):

```sh
npx skills add Jacky97s/bambu-account
```

Then just ask, e.g. "switch Bambu Studio to my home account". The agent
installs the `bambu-account` CLI itself if it's missing, and asks you to quit
Bambu Studio when needed.

## Manual install

```sh
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/Jacky97s/bambu-account/main/bambu-account -o ~/.local/bin/bambu-account
chmod +x ~/.local/bin/bambu-account
```

Make sure `~/.local/bin` is on your `PATH`.

## Usage

Quit Bambu Studio (Cmd+Q) before `use` or `logout`.

```sh
bambu-account save work    # back up the account you're logged in to as "work"
bambu-account logout       # log out (current login is kept as "_last")
# open Bambu Studio, log in to your other account, quit it, then:
bambu-account save home

bambu-account use work     # switch to "work"
bambu-account use home     # switch to "home"
bambu-account list         # list saved accounts
```

Every `use` and `logout` first backs up the current login as `_last`, so
`bambu-account use _last` undoes the last switch.

## Notes

- Saved logins live in `~/.bambu-accounts/` (mode 700). They are login
  tokens: don't share or commit them.
- Only the login is switched. Settings in `BambuStudio.conf` (region, last
  printer, LAN access codes, presets) are shared between accounts.
- A saved token can expire; if Bambu Studio asks you to log in again, log in
  and run `bambu-account save <name>` again.
- Bambu Connect keeps its own login and is not affected.
- macOS only (see [Contributing](#contributing)). Not affiliated with Bambu Lab.

## Test

```sh
./test.sh   # runs against a temp dir, never touches your real config
```

## Contributing

Windows and Linux support is welcome. Bambu Studio's config folder is
`%APPDATA%\BambuStudio` on Windows and usually `~/.config/BambuStudio` on
Linux (`~/.var/app/com.bambulab.BambuStudio/config/BambuStudio` for Flatpak),
but whether the login lives in `BambuNetworkEngine.conf` there too hasn't
been verified. If you can test on those platforms, please open a pull request
with the change and the result of `./test.sh` (or an equivalent test).
