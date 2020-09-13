devices=('angler' 'angler_4core' 'evert' 'fajita' 'ginkgo' 'mata' 'oneplus3' 'beryllium' )

function lunch_devices() {
    add_lunch_combo awaken_${device}-user
    add_lunch_combo awaken_${device}-userdebug
}

for device in ${devices[@]}; do
    lunch_devices
done
