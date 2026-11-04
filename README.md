# Weasis AppImage (unofficial)

Unofficial AppImage repackaging of [Weasis](https://github.com/nroduit/Weasis), the open-source
DICOM viewer. This project is **not affiliated with or endorsed by the Weasis project**. Report
Weasis bugs upstream and packaging problems here.

A scheduled workflow checks daily for a new **stable** upstream release (never pre-releases or
drafts), takes the upstream `.deb` for `amd64` and, when published, `arm64`, repackages it with
[linuxdeploy](https://github.com/linuxdeploy/linuxdeploy) leaving the application tree unmodified (only the `.desktop` entry is adjusted),
and publishes the result as a release in this repository. Both architectures are built on native
runners. CI smoke-tests each image (it unpacks, the bundled Java runs, the launcher and `weasis://`
entry are present) but never launches the app.

> Weasis is not a certified medical device (CE or FDA). Any primary diagnostic use requires you to
> ensure full compliance with the laws and regulations applicable in your jurisdiction.

## Why this exists

The upstream maintainer [declined an AppImage](https://github.com/nroduit/Weasis/pull/961): no
`weasis://` registration, no sandbox or update channel, one more Linux format to support. This
repository is for users who still want a portable, install-free build, kept apart from the official
project. The limits are listed below.

## Download and verify

Each release has, per architecture (`x86_64`, `aarch64`):

- `Weasis-<version>-<arch>.AppImage` and its `.sha256`
- `Weasis-<version>-<arch>.AppImage.zsync` for delta updates
- `Weasis-<version>-<arch>.licenses.tar.gz`: third-party notices, license texts, the license and
  notice files of the upstream package and of its bundled jars, and the Java runtime build
  information

```bash
sha256sum -c Weasis-<version>-<arch>.AppImage.sha256
gh attestation verify Weasis-<version>-<arch>.AppImage --repo alberto743/weasis-appimage
```

`gh attestation` needs GitHub CLI 2.49 or newer.

The workflow also checks the upstream `.deb` against the digest GitHub records for the release
asset. Upstream publishes no checksum files, so this protects the transfer only.

## Run

```bash
chmod +x Weasis-<version>-<arch>.AppImage
./Weasis-<version>-<arch>.AppImage
```

If FUSE 2 is not installed (default on recent Ubuntu), use `--appimage-extract-and-run` or install
`libfuse2`. Updates: `appimageupdatetool Weasis-<version>-<arch>.AppImage`.

### Install with appjail (optional)

[appjail](https://github.com/alberto743/appjail) installs and runs AppImages from GitHub releases
in a bubblewrap sandbox, with pinned hashes, update quarantine and per-app permissions. It can
install this AppImage from this repository's releases and addresses the sandbox and update limits
below. It is optional: the AppImage works without it. Weasis requires `xwayland-rootful` to be
installed when it is run through appjail.

## Limits compared with the native packages

- **`weasis://` links** from web portals do nothing until the desktop entry is installed by an
  integration tool. The entry declares `x-scheme-handler/weasis`, but its `Exec=` points to the
  AppImage location, so moving or replacing the file breaks the handler until the entry is
  refreshed.
- **No sandbox and no signature check** by the AppImage format itself. The file is a user-writable
  executable. Verify checksums and attestations, or run it under a sandbox.
- Only the Weasis launcher is exposed; Dicomizer is inside the bundle but has no entry.
- Same glibc floor as the upstream `.deb`.
- On optical media the file needs its executable bit (Rock Ridge/UDF) and a mount without
  `noexec`.

## Building

Releases are built by `.github/workflows/build-appimage.yml`. Manual run inputs:

- `tag`: an older stable version (e.g. `v4.7.3`). It needs a digest recorded by GitHub for the
  upstream `.deb`, which is verified against it.
- `revision`: a packaging-only fix, published as `vX.Y.Z-rN` without touching the existing release.
- `force`: overwrite an existing release.

An architecture is built only if upstream published a `.deb` for it. Two consecutive failed runs
block scheduled runs and open an issue; a run that does not end in two failures reopens the gate.

Build tools are pinned by version and SHA-256 in `tools.env`; a weekly workflow opens a pull
request for newer releases. GitHub Actions are pinned by commit SHA and updated by Dependabot.

## Licensing

The scripts and workflows in this repository are licensed under the
[MPL-2.0](LICENSES/MPL-2.0.txt) and the repo follows the [REUSE](https://reuse.software)
specification.

The AppImage is an aggregate of third-party software that is **not** relicensed by this
repository. [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md) lists each component, its license and
its source, and every release ships it with the license files from the upstream package in the
`.licenses.tar.gz` asset.

- Weasis: EPL-2.0 OR Apache-2.0 ([upstream](https://github.com/nroduit/Weasis)). Source is available
  at the upstream release tag.
- The bundled Java runtime (Eclipse Temurin) is GPL-2.0 with the Classpath Exception.
- LGPL components (Docking Frames, Java ISO Tools, VectorGraphics2D) can be replaced: unpack the
  AppImage with `--appimage-extract`.
- The image codecs in the OpenCV library include code from the Independent JPEG Group: this
  software is based in part on the work of the Independent JPEG Group.
- The AppImage runtime ([type2-runtime](https://github.com/AppImage/type2-runtime)) is embedded in
  each file.

## Trademarks

"Weasis" is the name of the upstream project and is used here only to identify the software this
package contains. This repository is not affiliated with or endorsed by the Weasis project, and the
name, icon and logo remain those of their owners. Apache-2.0 and EPL-2.0 grant no trademark rights.

## Concerns from rights holders and the Weasis project

If you are the Weasis maintainer or a rights holder of a bundled component and something here is
not acceptable (a missing or wrong notice, a name, icon or logo, or a wish that this repository not
exist), open an issue or contact the owner through their GitHub profile. No legal wording is
needed; valid concerns will be corrected, or the affected releases renamed or withdrawn.
