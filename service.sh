#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
  sleep 5
done

sleep 10

TMP_DIR="/dev/gpu_fix"
mkdir -p "$TMP_DIR"

echo "1000000" > "$TMP_DIR/max"
echo "1" > "$TMP_DIR/on"
echo "always_on" > "$TMP_DIR/policy"

mount --bind "$TMP_DIR/max" /sys/module/ged/parameters/gpu_bottom_freq
mount --bind "$TMP_DIR/max" /sys/module/ged/parameters/gpu_cust_upbound_freq
mount --bind "$TMP_DIR/max" /sys/module/ged/parameters/gpu_cust_boost_freq
mount --bind "$TMP_DIR/on" /sys/module/ged/parameters/boost_gpu_enable
mount --bind "$TMP_DIR/on" /sys/module/ged/parameters/enable_gpu_boost
mount --bind "$TMP_DIR/policy" /sys/class/misc/mali0/device/power_policy

M_PATH="/sys/devices/platform/13040000.mali/devfreq/13040000.mali"

# Cria os arquivos com os valores que você quer travar
echo "1000000" > "$TMP_DIR/gpu_max"
echo "performance" > "$TMP_DIR/gpu_gov"

# Força o sistema a ler os SEUS arquivos no lugar dos originais
mount --bind "$TMP_DIR/gpu_max" "$M_PATH/max_freq"
mount --bind "$TMP_DIR/gpu_gov" "$M_PATH/governor"

# Opcional: Tenta travar a freq mínima também para não cair
echo "1000000" > "$TMP_DIR/gpu_min"
mount --bind "$TMP_DIR/gpu_min" "$M_PATH/min_freq" 2>/dev/null

echo "GPU Fix Aplicado via Mount Bind!"

