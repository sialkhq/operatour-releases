# Operatour releases

Downloads for [Operatour](https://www.sialk.net/operatour), the simple
live-visuals application: pick a visual, it hears the room, and it runs on
your stage tonight. It plays GLSL, p5 and Three.js today; Cables.gl, Rive and
Spline are coming, in that order.

**Get the beta, a disk image or a zip of the same signed build, and how to open it:** https://www.sialk.net/operatour/beta

**Every release, with what changed:** https://www.sialk.net/operatour/releases

Operatour was called Sialk Operator until October 2026. Builds up to beta
0.3.0 carry the old name; later ones are named `Operatour-beta-macOS`.

This repository holds release files and nothing else. The application is not
open source; the audio contract, the browser shim and the examples are
published separately under MIT at
[sialkhq/audio-contract](https://github.com/sialkhq/audio-contract), because
the whole point of a contract is that people write against it. Operatour is
made by [Sialk LTD](https://www.sialk.net), London, which also makes
[Playery](https://www.sialk.net/playery), the player for the wall.

## Verify a download

```
shasum -a 256 Operatour-beta-macOS.dmg
shasum -a 256 Operatour-beta-macOS.zip
```

Checksums for each release are listed on its release page.
