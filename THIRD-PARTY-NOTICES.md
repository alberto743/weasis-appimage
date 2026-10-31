<!--
SPDX-FileCopyrightText: 2026 Alberto P
SPDX-License-Identifier: MPL-2.0
-->

# Third-party notices

The AppImage contains the unmodified Weasis application tree from the upstream `.deb`. None of the
components below is relicensed by this repository. This file is shipped in each release inside
`Weasis-<version>-<arch>.licenses.tar.gz`, together with the license and notice files found in the
`.deb` and inside its bundled jars (including nested jars), the standard license texts in
`third-party-licenses/`, the runtime's `legal` tree and its `release` file.

Source for everything below is available from the upstream release tag
(`https://github.com/nroduit/Weasis/tree/<tag>`) and from the project links given in each row.

"Verified" means the license was read from the v4.8.0 artifacts or the project's own license file.
"To confirm" means it comes from general knowledge of the project and must be checked against the
bundled version before a release is published.

## Weasis and its own libraries

| Component | License | Status |
|---|---|---|
| Weasis (all `weasis-*` bundles, `weasis-core-img`, `weasis-dicom-tools`) | EPL-2.0 OR Apache-2.0 | Verified (upstream `LICENSE`) |

Recipients may choose either license. The license texts are in the upstream repository
(`LICENSE.EPL-2.0`, `LICENSE.Apache-2.0`). Under EPL-2.0 the source of the program is available at
the upstream repository link above.

## Code embedded in Weasis bundles

| Component | License | Where | Status |
|---|---|---|---|
| dcm4che 5.x (`org.dcm4che3.*`, via `weasis-dicom-tools`) | MPL-1.1 OR GPL-2.0-or-later OR LGPL-2.1-or-later (tri-license) | `weasis-dicom-codec` | Verified in the dcm4che repository (source header, `LICENSE.txt`); exact bundled version to confirm |
| Docking Frames | LGPL-2.1 | `docking-frames` bundle | Verified (bundle manifest) |
| Java ISO Tools (`iso9660-writer`, `sabre`) | LGPL-2.1 | `weasis-dicom-isowriter` | Verified (project `LICENSE`) |
| Apache Felix (framework, SCR, Config Admin, Gogo, Prefs, Bundle Repository) | Apache-2.0 | bundles and launcher | Verified (bundle manifests) |
| OSGi `org.osgi.service.component`, `osgi.promise` | Apache-2.0 | bundles | Verified (bundle manifests) |
| MiGLayout | BSD (Debian BSD license URL in the manifest) | bundles | To confirm the exact variant |
| JOML | MIT | bundle | Verified (project license) |
| OSHI | MIT | `weasis-core` | Verified (project license) |
| XChart | Apache-2.0 | `weasis-core` | Verified (project license) |
| FlatLaf | Apache-2.0 | launcher | Verified (project license) |
| FlatLaf IntelliJ themes | Per-theme licenses (Apache-2.0, MIT) | launcher | To confirm |
| JAXB reference implementation (`jaxb-osgi`) | BSD-3-Clause (EDL 1.0) | bundle | Verified (project license) |
| Jakarta Activation, Jakarta XML Bind API, istack-commons, TXW2 | BSD-3-Clause (EDL 1.0), some also GPL-2.0-with-classpath-exception | `jaxb-osgi` | To confirm |
| JogAmp (JOGL, GlueGen, JOCL and natives) | BSD-2-Clause | `jogamp*` bundles | To confirm (upstream bundle metadata says EPL-2.0 OR Apache-2.0) |
| Parsson, Jakarta JSON API | EPL-2.0 OR GPL-2.0-with-classpath-exception | `weasis-core` | To confirm |
| VectorGraphics2D | MIT | `weasis-core` | To confirm |
| zip4j | Apache-2.0 | bundle | To confirm |
| SLF4J, Logback | MIT; EPL-1.0 OR LGPL-2.1 | launcher | To confirm |
| XZ for Java | 0BSD / public domain | launcher | To confirm |

Where a component is dual- or tri-licensed, the recipient may use it under any of the offered
licenses. For the LGPL components the user can replace the library: the AppImage is a compressed
read-only image that can be unpacked with `--appimage-extract` and repacked.

### Components without a license file in their jar

The inner jars of OSHI, XChart, VectorGraphics2D, JogAmp (JOGL, GlueGen, JOCL) and Java ISO Tools
contain no license or notice file, so the release archive has none for them beyond the generic
texts in `third-party-licenses/` (MIT, Apache-2.0, BSD-2-Clause, LGPL-2.1-only). Their project
copyright lines must be added from the exact bundled versions before the first public release.

## Native code in the OpenCV library (`libopencv_java.so`)

Built from OpenCV 5.x (Apache-2.0) with the Weasis DICOM extensions. Its build information lists
these statically linked 3rd-party libraries; no FFmpeg is included.

| Library | License | Status |
|---|---|---|
| libjpeg-turbo | BSD-3-Clause, IJG, Zlib | To confirm |
| IJG libjpeg 6b | IJG (see statement below) | Verified (upstream `3rd-party-licenses.md`) |
| OpenJPEG (`libopenjp2`) | BSD-2-Clause | Verified (upstream `3rd-party-licenses.md`) |
| CharLS | BSD-3-Clause | Verified (upstream `3rd-party-licenses.md`) |
| libpng | libpng license | To confirm |
| libtiff | libtiff (BSD-style) | To confirm |
| libjxl | BSD-3-Clause | To confirm |
| zlib | Zlib | To confirm |
| CLAPACK | BSD-style | To confirm |

BSD-style licenses require that the copyright notice and disclaimer are reproduced with binary
distributions. `third-party-licenses/` holds the generic license texts only; the project-specific
copyright notices of these libraries, taken from the exact bundled versions, must be added before
the first public release.

### Independent JPEG Group notice

This software is based in part on the work of the Independent JPEG Group.

## Java runtime

The bundled runtime is an Eclipse Temurin (OpenJDK) image created with `jlink`, licensed under
GPL-2.0 with the Classpath Exception. Its license files are under `lib/runtime/legal`, and the
`release` file in the notices archive records the exact build. Source:
<https://github.com/adoptium> and <https://github.com/openjdk>.

## AppImage tooling

- [type2-runtime](https://github.com/AppImage/type2-runtime) is embedded in every AppImage
  (MIT, with its own statically linked components; see its repository for the notices).
- linuxdeploy and its AppImage plugin only run at build time and are not shipped.

## Names and artwork

"Weasis" is the name of the upstream project. The icon and logo are redistributed unmodified from
the upstream package, under the license upstream gives its resources (Apache-2.0 per
`3rd-party-licenses.md`), which grants no rights in names or trademarks. This repository claims no
affiliation with, or endorsement by, the Weasis project.
