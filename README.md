# Windows Kernel Driver Development on Linux using Wine and Qemu

This project provides a Makefile-based build system for developing and compiling Windows XP **WDM** or **KMDF** drivers entirely on a **Linux** environment using **Wine**. It leverages the Microsoft Windows XP SP1 Driver Development Kit (DDK) and MSVC toolchain, running via Wine, to produce `.sys` driver binaries without requiring a native Windows system.

---

## 📁 Project Structure

```bash
.
├── build            # Output directory for .sys and .pdb files
├── cdrom            # Autorun script files for CD-ROM ISO
├── inc              # Header files
├── lib              # Additional .lib libraries
├── Makefile         # Build system using MSVC under Wine
├── objs             # Intermediate object files
├── README.md        # ReadME Document
└── src              # C source files for the driver
    ├── main.c
    └── utils.c
```

---

## ✅ Features

- Compile Windows XP kernel-mode drivers on Linux
- Uses Wine to run `cl.exe` and `link.exe` from the DDK
- Builds `.sys` and `.pdb` files with full debug info
- Automatic CD-ROM ISO packaging for QEMU boot testing
- Includes bootable QEMU configuration

---

## 🔧 Requirements

- Linux (tested on Ubuntu/Debian-based distros)
- `wine` (with 32-bit prefix setup)
- `genisoimage` (to create ISO files)
- `qemu-system-i386` (for testing driver in Windows XP VM)
- Windows XP SP1 DDK installed inside Wine (e.g., `~/.wine32/drive_c/WINDDK`)

To set up Wine:

```bash
export WINEPREFIX=$HOME/.wine32
export WINEARCH=win32
winecfg  # Run this once to initialize the prefix
```

---

## 🛠 Build Instructions

To build the driver:

```bash
make
```

- This compiles the source files from `src/`
- Creates object files in `objs/`
- Outputs the driver (`main.sy`s) and debug symbols (`main.pdb`) in build/

To clean the build artifacts:

```bash
make clean
```

---

## 🧪 Running in QEMU

This setup includes the ability to test the driver in a virtualized Windows XP environment using QEMU.
Ensure your Windows XP VM image exists at:

```bash
${HOME}/imgs/winxp_nano.img
```

Then run:

```bash
make run
```

This command will:

1. Build the driver if needed
2. Create a CD-ROM ISO with:
   - `main.sys`,  driver
   - `main.pdb`,  debug info
   - `autorun`.inf and `run.bat` to auto-load the driver
3. Boot Windows XP in QEMU with the ISO mounted

You can modify cdrom/run.bat to suit your driver loading proces

---

## 📎 Customization

- Add `.c` files to `src/` – they’ll be compiled automatically
- Add headers to `inc/` for local includes
- Place `.lib` files in `lib/` – they’ll be linked with the driver
- Modify `autorun.inf` and `run.bat` under `cdrom/` for testing automation

---

## ⚙️ Makefile Notes

This build system uses:

- MSVC `cl.exe` for compiling
- `link.exe` with `/DRIVER` and `/SUBSYSTEM:NATIVE`
- Minimal runtime dependencies
- Driver entry point: `DriverEntry`

Example driver flags:

```c
/D_WIN32_WINNT=0x0501
/DNTDDI_VERSION=0x05010100
/D_X86_=1
/DWINXP
```

Linker flags specify driver base address, no default CRT libs, and debug symbols.

---

## 📄 License

This project is released under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 🗨️ Acknowledgements

- Microsoft Windows XP SP1 DDK
- Wine for enabling cross-platform development
- QEMU for rapid testing in virtual environments
