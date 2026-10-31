<!--
SPDX-FileCopyrightText: 2026 Alberto P
SPDX-License-Identifier: MPL-2.0
-->

# Third-party notices

The AppImage contains the unmodified Weasis application tree from the upstream `.deb`. None of the
components below is relicensed by this repository. This file is shipped in each release inside
`Weasis-<version>-<arch>.licenses.tar.gz`, together with:

- `third-party-licenses/`: the standard license texts, and `third-party-licenses/notices/<component>/`
  with the license file or license header of each component below and a `SOURCE.txt` giving the
  bundled version, the upstream repository, the tag and the path it was copied from
- `deb/` and `jars/`: the license and notice files found in the upstream `.deb` and inside its
  bundled jars (including nested jars)
- `runtime-legal/`: the legal tree of the bundled Java runtime, and `deb/.../release` for its build

Source for everything below is available from the upstream release tag
(`https://github.com/nroduit/Weasis/tree/<tag>`) and from the project links in each
`SOURCE.txt`.

"Verified" means the license was read from a license file or source header of the project at the
bundled version (or the closest tag, stated in `SOURCE.txt`), or from the bundled jar itself.
"To confirm" means a point that still needs a human check against the bundled binary.

## Weasis and its own libraries

| Component | License | Status |
|---|---|---|
| Weasis (all `weasis-*` bundles, `weasis-core-img`, `weasis-dicom-tools`) | EPL-2.0 OR Apache-2.0 | Verified (upstream `LICENSE`) |

Recipients may choose either license. The license texts are in the upstream repository
(`LICENSE.EPL-2.0`, `LICENSE.Apache-2.0`) and in `third-party-licenses/`.

## Code embedded in Weasis bundles

| Component | Version | License | Notice folder | Status |
|---|---|---|---|---|
| dcm4che (`org.dcm4che3.*`, via `weasis-dicom-tools`) | 5.35.2 | MPL-1.1 OR GPL-2.0-or-later OR LGPL-2.1-or-later | `dcm4che` | Verified (LICENSE.txt and source header at 5.35.2) |
| Docking Frames | 1.1.7 | LGPL-2.1-or-later | `docking-frames` | Verified (source header, master; no 1.1.7 tag) |
| Java ISO Tools (`iso9660-writer`, `sabre`) | 2.1.0 | LGPL-2.1-or-later | `java-iso-tools` | Verified |
| VectorGraphics2D | 0.13 | LGPL-3.0-or-later | `vectorgraphics2d` | Verified (LICENSE.LGPL and headers at 0.13) |
| Apache Felix framework and bundles | 7.0.5 and others | Apache-2.0 | `apache-felix-framework`, `jars/` | Verified (LICENSE; NOTICE files inside the bundle jars; none at the framework tag) |
| OSGi `org.osgi.service.component`, `osgi.promise` | 1.5.1, 8.1.0 | Apache-2.0 | `jars/` | Verified (jar license files) |
| MiGLayout | 11.4.3 | BSD-3-Clause | `miglayout` | Verified (source header at v11.4.2, nearest tag) |
| JOML | 1.10.9 | MIT | `joml` | Verified |
| OSHI | 7.6.0 | MIT | `oshi` | Verified |
| XChart | 4.0.4 | Apache-2.0 | `xchart` | Verified |
| zip4j | 2.11.6 | Apache-2.0 | `zip4j` | Verified |
| FlatLaf | 3.7.2 | Apache-2.0 | `flatlaf` | Verified |
| FlatLaf IntelliJ themes | 3.7.2 | Per-theme licenses | not collected | To confirm |
| SLF4J | 2.0.18 | MIT | `slf4j` | Verified |
| Logback | 1.6.1 | EPL-1.0 OR LGPL-2.1-only | `logback` | Verified |
| XZ for Java | 1.12 | 0BSD | `xz-java` | Verified |
| JOGL, GlueGen, JOCL and natives | 2.6.0 | BSD-2-Clause, plus other compatible licensed material listed in the files | `jogl`, `gluegen`, `jocl` | Verified (upstream bundle metadata labels them EPL-2.0 OR Apache-2.0, which does not match) |
| Jakarta JSON API, Parsson | 2.1.3, 1.1.7 | EPL-2.0 (GPL-2.0 with Classpath Exception as Secondary License) | `jars/` | Verified (jar license and notice files) |
| JAXB reference implementation, Jakarta Activation, Jakarta XML Bind API, TXW2, istack-commons | 4.0.3 and others | BSD-3-Clause (EDL 1.0) | `jars/` | Verified (jar license and notice files; istack-commons to confirm) |

Where a component is dual- or tri-licensed, the recipient may use it under any of the offered
licenses. For the LGPL components the user can replace the library: the AppImage is a compressed
read-only image that can be unpacked with `--appimage-extract` and repacked.

## Native code in the OpenCV library (`libopencv_java.so`)

Built from OpenCV 5.0.0 (Apache-2.0) with the Weasis DICOM extensions. Its build information lists
these statically linked 3rd-party libraries and their versions; no FFmpeg is included.

| Library | Version | License | Notice folder | Status |
|---|---|---|---|---|
| OpenCV | 5.0.0 | Apache-2.0 | `opencv` | Verified |
| libjpeg-turbo | 3.1.2 | BSD-3-Clause, IJG, Zlib | `libjpeg-turbo` | Verified |
| IJG libjpeg | 6b | IJG (see statement below) | `libjpeg-turbo` (README.ijg) | Verified |
| OpenJPEG (`libopenjp2`) | 2.5.4 | BSD-2-Clause | `openjpeg` | Verified |
| CharLS | 3.0.0 | BSD-3-Clause | `charls` | Verified (default branch; no 3.0.0 tag) |
| libpng | 1.6.57 | PNG Reference Library License v2 | `libpng` | Verified |
| libtiff | 4.7.1 | libtiff license | `libtiff` | Verified |
| libjxl | 0.11.2 | BSD-3-Clause | `libjxl` | Verified |
| zlib | 1.3.2 | Zlib | `zlib` | Verified |
| CLAPACK (OpenCV 3rdparty copy) | OpenCV 5.0.0 | Modified BSD (LAPACK license) | `clapack` | Verified |

### Independent JPEG Group notice

This software is based in part on the work of the Independent JPEG Group.

## Java runtime

The bundled runtime is an Eclipse Temurin (OpenJDK) image created with `jlink`, licensed under
GPL-2.0 with the Classpath Exception. Its license files are in `runtime-legal/`, and the `release`
file records the exact build. Source: <https://github.com/adoptium> and
<https://github.com/openjdk>.

## AppImage tooling

- [type2-runtime](https://github.com/AppImage/type2-runtime) is embedded in every AppImage
  (MIT, with its own statically linked components; to confirm against the pinned release).
- linuxdeploy and its AppImage plugin only run at build time and are not shipped.

## Names and artwork

"Weasis" is the name of the upstream project. The icon and logo are redistributed unmodified from
the upstream package, under the license upstream gives its resources (Apache-2.0 per
`3rd-party-licenses.md`), which grants no rights in names or trademarks. This repository claims no
affiliation with, or endorsement by, the Weasis project.

## Remaining checks before a public release

- FlatLaf IntelliJ themes: collect the per-theme licenses from the artifact.
- istack-commons: confirm its license file inside `jaxb-osgi`.
- type2-runtime: collect the notices of its statically linked components.
- Version mismatches recorded in `SOURCE.txt` (CharLS, Docking Frames, MiGLayout) should be
  compared with the exact source of the bundled binaries if available.
