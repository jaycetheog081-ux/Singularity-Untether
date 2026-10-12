TARGET := iphone:clang:latest:12.0
ARCHS = arm64

THEOS_PACKAGE_SCHEME = rootful

include $(THEOS)/makefiles/common.mk

TOOL_NAME = singularity

singularity_FILES = main.mm
singularity_FRAMEWORKS = Foundation
singularity_INSTALL_PATH = /usr/bin
singularity_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
include $(THEOS_MAKE_PATH)/package.mk
