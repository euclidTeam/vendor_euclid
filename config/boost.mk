EUCLID_CPU_SMALL_CORES ?= 0,1,2,3
EUCLID_CPU_BIG_CORES ?= 4,5,6,7
EUCLID_ALL_CORES ?= 0-7
EUCLID_CPU_SYS_BG ?= 0-3
EUCLID_CPU_BG ?= 0-2
EUCLID_CPU_FG ?= 0-5
EUCLID_CPU_LIMIT_BG ?= 0-1
EUCLID_CPU_LIMIT_UI ?= 0-2
EUCLID_CPU_DISPLAY ?= 0-5

# boost properties
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.euclid_cpu_big=$(EUCLID_CPU_BIG_CORES) \
    persist.sys.euclid_cpu_small=$(EUCLID_CPU_SMALL_CORES) \
    persist.sys.euclid_cpu_bg=$(EUCLID_CPU_BG) \
    persist.sys.euclid_cpu_sys_bg=$(EUCLID_CPU_SYS_BG) \
    persist.sys.euclid_cpu_limit_bg=$(EUCLID_CPU_LIMIT_BG) \
    persist.sys.euclid_cpu_fg=$(EUCLID_CPU_FG) \
    persist.sys.euclid_cpu_limit_ui=$(EUCLID_CPU_LIMIT_UI) \
    persist.sys.euclid_cpu_unlimit_ui=$(EUCLID_ALL_CORES) \
    persist.sys.euclid_cpu_display=$(EUCLID_CPU_DISPLAY)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.surface_flinger.uclamp.min=100
