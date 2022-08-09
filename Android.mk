#
# Copyright (C) 2022 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter mi8937 mi439 tiare oxygen uter vince ysl,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))

endif
