# "Update Available" — Design Notes

Working notes for deciding what the **Update Available** menu item should do when the
background/manual check finds a newer GitHub release. Nothing here is final — this is a
parking spot to think about later.

## Current state (already implemented)

- Background check runs at startup on its own runspace (`Start-BackgroundUpdateCheck`),
  polled on the UI thread via a `DispatcherTimer`.
- Manual check lives under **About → Check for Updates**.
- Shared logic is the `$Script:TestForUpdate` scriptblock (used by both paths).
- When a newer release exists, `Show-UpdateAvailable` reveals the accent-colored
  top-level **Update Available: v<latest>** menu item.
- The item's click handler currently just opens the release/releases page
  (`$Script:LatestReleaseUrl`, falling back to `$Script:ReleasesPageUrl`).
- "No update / up to date" is intentionally **silent** for now.

## The core problem

"Update" means something different depending on how the script was launched, and each
channel has its own *correct* update mechanism. A single one-size-fits-all self-update is
not safe — most importantly, a PowerShell Gallery install must be updated with
`Update-Script`, not by overwriting the file.

## Distribution channels

| How it's running | How to detect | Correct update action |
|---|---|---|
| From the web (`iex (irm ...)`) | `$PSCommandPath` is empty | Nothing — the next launch already pulls `main` (latest) |
| PowerShell Gallery (`Install-Script`) | `Get-InstalledScript GetMSIInformation` location matches `$PSCommandPath` | `Update-Script GetMSIInformation` |
| Right-click menu | `$PSCommandPath` is under `$env:LOCALAPPDATA\GetMSIInformation` | Refresh the copy + registry (reuse the `Install` handler logic) |
| Loose local `.ps1` | none of the above, `$PSCommandPath` is set | Overwrite that file, or just open the releases page |

### Detection notes

- Web vs file: `[string]::IsNullOrEmpty($PSCommandPath)`.
- PSGallery: `Get-InstalledScript -Name GetMSIInformation -ErrorAction SilentlyContinue`,
  then compare its `InstalledLocation` to `Split-Path $PSCommandPath`.
  - Beware: AllUsers scope installs may live under `C:\Program Files\...` and updating
    there can require elevation.
- Right-click install: compare `Split-Path $PSCommandPath` to
  `$Script:RightClickMenuFolderPath` (`$env:LOCALAPPDATA\GetMSIInformation`).

## Options considered

### Option A — Smart router (recommended)
The click detects the channel and does the right thing:
- **PSGallery** → run `Update-Script GetMSIInformation -Force`, then offer to relaunch.
- **Right-click install** → refresh the LOCALAPPDATA copy + registry.
- **Web / loose file** → open the releases page (note that PSGallery users can `Update-Script`).

Each branch is small and reuses code that already exists. Every branch should fall back to
"open the releases page" on any failure, so it degrades gracefully.

Pros: "just works" per channel; matches the app's single-file, auto-relaunch philosophy.
Cons: most surface area / most to test.

### Option B — Simple page-open + PSGallery hint
The click just opens the releases page for everyone. If a PSGallery install is detected,
show a one-line hint to run `Update-Script GetMSIInformation`.

Pros: near-zero risk, minimal code.
Cons: manual for the user.

### Option C — Right-click refresh only
Only offer to refresh the installed right-click copy. Narrow, and surprising because the
currently-open window stays on the old version.

## Open questions / decisions to make

- Pick a direction: **A (smart router)** vs **B (simple + hint)**.
- Should "Update & Restart" relaunch the open window, or just update on disk and let the
  user reopen? (Relaunch needs the new version on disk first; from-web can relaunch the
  `iex (irm ...)` one-liner which is always latest.)
- Confirm no elevation is needed for the common cases (right-click + CurrentUser PSGallery
  both write to HKCU / LOCALAPPDATA / user scope — no admin). AllUsers PSGallery is the
  exception.
- Keep the "up to date" case silent, or add a small confirmation for the *manual* check
  so the user knows it actually ran?

## Relevant code anchors (current file)

- `$Script:TestForUpdate` — shared update-check scriptblock.
- `Start-BackgroundUpdateCheck` — runspace + `DispatcherTimer` polling.
- `Show-UpdateAvailable` — reveals the menu item; sets `$Script:LatestReleaseUrl`.
- `$MenuItem_UpdateAvailable.add_Click` — currently opens the release page.
- `$MenuItem_Install.add_Click` — existing logic to download latest + write registry
  (reusable for the right-click "refresh" branch).
- `Invoke-LaunchAsPwsh` — existing relaunch patterns (file vs web one-liner).
