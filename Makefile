# Makefile for compiling WDM/KMDF driver using MSVC under WINE on Linux
# Targeting Windows XP SP1 DDK

# defined default CFLAGS/LDFLAGS and libraries
include mak/config.mk

# Source files
# Automatically find all .c source files in SRC_DIR
SOURCES := $(wildcard $(SRC_DIR)/*.c)
# Generate corresponding .obj file paths in OBJ_DIR
OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.obj,$(SOURCES))

# Target driver name
TARGET = $(BUILD_DIR)/main.sys

# Default target
all: $(TARGET)

# Create necessary directories
$(OBJ_DIR) $(BUILD_DIR):
	mkdir -p $@

# Compile source files to object files
$(OBJ_DIR)/%.obj: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CL) $(CFLAGS) /Fo$@ $<

# Link object files to create the driver
$(TARGET): $(OBJECTS) | $(BUILD_DIR)
	$(LINK) $(LDFLAGS) /OUT:$@ $(OBJECTS) $(LIBS)

# all files into cdrom.iso
files_cdrom := inf_autorun batch_run sys_main pdb_main
inf_autorun := autorun.inf=$(CDROM_DIR)/autorun.inf
batch_run := run.bat=$(CDROM_DIR)/run.bat
sys_main := main.sys=$(BUILD_DIR)/main.sys
pdb_main := main.pdb=$(BUILD_DIR)/main.pdb

# qemux86: launch QEMU
# OS: XP OS image
run: $(TARGET)
	rm -rf $(BUILD_DIR)/cdrom
	genisoimage -o $(BUILD_DIR)/cdrom.iso -R -J -graft-points  $(foreach pair,$(files_cdrom),$($(pair)))
	$(call qemux86,$(OS))
	@echo

# Clean up
clean:
	rm -rf $(OBJ_DIR)/*.obj $(BUILD_DIR)/*.sys $(BUILD_DIR)/*.pdb ./*.pdb $(BUILD_DIR)/*.iso

# Phony targets
.PHONY: all clean
