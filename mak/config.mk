# mak/config.mk
# Default configuration

# WINE configuration
WINEPREFIX = $(HOME)/.wine32
WINEARCH = win32
WINEDLLOVERRIDES="winex11.drv=disabled"
WINE =  WINEDLLOVERRIDES=$(WINEDLLOVERRIDES) \
	WINEPREFIX=$(WINEPREFIX) \
	WINEARCH=$(WINEARCH) \
	wine

define winepath
$(shell WINEPREFIX=$(WINEPREFIX) $(WINE) winepath -w $(abspath $1))
endef

# DDK installation path (mapped via WINE)
DDK_PATH = C:\\WINDDK

# MSVC compiler and linker (from XP SP1 DDK)
CL = $(WINE) $(DDK_PATH)\\bin\\x86\\cl.exe
LINK = $(WINE) $(DDK_PATH)\\bin\\x86\\link.exe

# Directories
SRC_DIR = src
INC_DIR = inc
LIB_DIR = lib
OBJ_DIR = objs
BUILD_DIR = build
CDROM_DIR = cdrom

# Include and library paths
DDK_INC_PATH = $(DDK_PATH)\\inc
DDK_LIB_PATH = $(DDK_PATH)\\lib
XP_INC_PATH = $(DDK_INC_PATH)\\wxp
DDK_XP_INC_PATH = $(DDK_INC_PATH)\\ddk\\wxp
WDM_INC_PATH = $(DDK_INC_PATH)\\ddk\\wdm\\wxp
CRT_INC_PATH = $(DDK_INC_PATH)\\crt

# LOCAL_INC_PATH  $(call winepath,$(INC_DIR))
LOCAL_INC_PATH = $(INC_DIR)
LOCAL_LIB_PATH = $(LIB_DIR)

# Compiler flags
# =============================================================
# -nologo    : without banner output
# -c         : compile only without linking
# -W3        : set warning level to 3
# -Zel       : unknown, but it is default option in DDK
# -Gz        : __stdcall calling convention
# -Zp8       : pack structs on 8byte boundary
# -Gy        : separate functions for linker
# -cbstring  :
# -Z7        : enable old-style debug info
# -QIfdiv-   : Don't emit code to test for bad pentiums
# -QIf       : Emit FPO records for every function
# -G6        : optimize for PPro, P-II, P-III
# -WX        : treat warnings as errors
CFLAGS = -nologo -c -W3 -Zel -Gz -Zp8 -Gy -cbstring -Z7 \
	 -QIfdiv- -QIf -G6 -WX \
         -D_WIN32_WINNT=0x0501 -DNTDDI_VERSION=0x05010100 \
         -DSTDCALL -D_X86_=1 -Di386=1 -DWINXP -DWIN32=100 \
         -DDEPRECATE_DDK_FUNCTIONS=1 \
         -I$(XP_INC_PATH) \
         -I$(DDK_XP_INC_PATH) \
         -I$(WDM_INC_PATH) \
         -I$(CRT_INC_PATH) \
         -I$(LOCAL_INC_PATH)

# Linker flags
LDFLAGS = -nologo -DRIVER -SUBSYSTEM:NATIVE -BASE:0x10000 -INCREMENTAL:NO \
          -ENTRY:DriverEntry -NODEFAULTLIB -DEBUG:FULL -DEBUGTYPE:CV \
          -LIBPATH:$(DDK_LIB_PATH)\\wxp\\i386 \
          -LIBPATH:$(DDK_LIB_PATH)\\crt\\i386 \
          -LIBPATH:$(LOCAL_LIB_PATH)

# Libraries to link (adjust based on your driver needs)
# DDK_LIBS = ntoskrnl.lib hal.lib wdm.lib
DDK_LIBS = ntoskrnl.lib csq.lib

# Add third-party libraries from lib directory (e.g., mylib.lib)
EXTRA_LIBS = $(wildcard $(LIB_DIR)/*.lib)
LIBS = $(DDK_LIBS) $(EXTRA_LIBS)


# XP OS image
OS   = ${HOME}/imgs/winxp_nano.img

define qemux86
  qemu-system-i386 \
    -m 2048M \
    -hda "$1" \
    -cdrom "$(BUILD_DIR)/cdrom.iso" \
    -vga cirrus \
    -display gtk \
    -boot c \
    -cpu host \
    -accel kvm \
    -M pc \
    -nic user,model=e1000 \
    -usb \
    -rtc base=localtime \
    -monitor stdio \
    -snapshot
endef
