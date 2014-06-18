Notes
=====

Building EPICS
--------------

The shipped epics Python package is all pure python and can be found at http://cars9.uchicago.edu/software/python/pyepics3. If this package requires upgrading then it should be a matter of simply overwriting the .py files in the `epics` directory. The package here also contains 2 dylibs and an executable that are not part of pyepics but instead come as part of the [EPICS](http://www.aps.anl.gov/epics/) base distribution. These libraries must be built and placed in the epics package to work correctly.

### Steps for building x86_64 libraries. Tested on Mountain Lion.
1. Get tarball for required version of EPICS base from http://www.aps.anl.gov/epics/download/base/index.php
2. Untar to a directory and change to this directory - referred to from here as EPICS_SRC_ROOT
3. Run `export EPICS_HOST_ARCH="darwin_x86"`
4. Open `EPICS_SRC_ROOT/configure/os/CONFIG_SITE.Common.darwin-x86
    - Uncomment the line `ARCH_CLASS = x86_64`
    - Add the line 
      `GNU_LDLIBS_YES = -L /usr/llvm-gcc-4.2/lib/gcc/i686-apple-darwin11/4.2.1/x86_64 -lgcc`
      to the end of the file
5. Type `make`
6. The libraries will appear in EPICS_SRC_ROOT/lib/darwin_x86 and binaries in EPICS_SRC_ROOT/bin/darwin_x86
7. Fix up the internal library paths using:
    - `install_name_change -id libCom3.14.12.dylib EPICS_SRC_ROOT/lib/darwin_x86/libCom.3.14.12.dylib`
    - `install_name_change -id libca3.14.12.dylib  EPICS_SRC_ROOT/lib/darwin_x86/libca.3.14.12.dylib`
    - `install_name_change -change EPICS_SRC_ROOT/lib/darwin_x86/libCom.3.14.12.dylib @loader_path/libCom.3.14.12.dylib EPICS_SRC_ROOT/lib/darwin_x86/libca.3.14.12.dylib`
    - `install_name_change -change EPICS_SRC_ROOT/lib/darwin_x86/libCom.3.14.12.dylib @loader_path/libCom.3.14.12.dylib EPICS_SRC_ROOT/bin/darwin_x86/caRepeater`
    - `install_name_change -change EPICS_SRC_ROOT/lib/darwin_x86/libca.3.14.12.dylib @loader_path/libca.3.14.12.dylib EPICS_SRC_ROOT/bin/darwin_x86/caRepeater`
8. Copy `caRepeater`, `libca.dylib`,`libca.3.14.12.dylib`,'libCom.3.14.12.dylib' to the root of the pyepics folder.

You may need to substitute a different version number for the EPICS version you are building.

### Testing
Running

    python -c "from epics import pv; x = pv.PV('something'); print x.get()"

should produce

    None

Any other output probably indicates an error.

