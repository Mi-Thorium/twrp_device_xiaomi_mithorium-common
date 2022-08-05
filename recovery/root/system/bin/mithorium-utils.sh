#!/system/bin/sh

set_device_codename() {
    resetprop "ro.build.product" "$1"
    resetprop "ro.omni.device" "$1"
    resetprop "ro.product.device" "$1"
    for i in odm product system system_ext vendor; do
        resetprop "ro.product.${i}.device" "$1"
    done
}

set_device_model() {
    resetprop "ro.product.model" "$1"
    for i in odm product system system_ext vendor; do
        resetprop "ro.product.${i}.model" "$1"
    done
}