# GCC-1.x

[TI S1500 / HP 9000-1500] TI GCC 1.x (public)

## Overview

* An experimental attempt at updating the
  [TI S1500 GCC](https://github.com/TI-S1500/GNU-S1500)
  port.

### Goals

1. Create a clean diff from
   [GCC 1.37.1](https://github.com/TI-S1500/GCC-1.x/tree/addb4d23b1b7f55157c2340c97a61510f7d8ef4a)
   to
   [GCC 1.37.1.1 (TI 1.1.06)](https://github.com/TI-S1500/GNU-S1500/tree/original/extracted/gcc-37).
2. Synchronize the
   [TI S1500 GCC](https://github.com/TI-S1500/GNU-S1500)
   port with mainline
   [GCC 1.41](https://github.com/TI-S1500/GCC-1.x/tree/e5243d0b8d09752ceda692eb41cff60cc2b8b140).

## Organization

* The
  [S1500 branch](https://github.com/TI-S1500/GCC-1.x/commits/S1500)
  contains mainline GNU GCC versions 1.35 through 1.37.1, and the
  TI-contributed S1500 GCC 1.37.1.1 (TI 1.1.06) port.
* The
  [mainline branch](https://github.com/TI-S1500/GCC-1.x/commits/mainline)
  contains mainline GNU GCC versions 1.35 through 1.41.
