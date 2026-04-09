#!/system/bin/sh
MODDIR=${0%/*}
LOG_FILE="/data/local/tmp/failsafes/gpu_universal.log"
mkdir -p /data/local/tmp/failsafes

log_msg() {
    echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1" > /dev/kmsg
}

echo "--- OTIMIZAÇÃO G85: PERFORMANCE MODE ---" > "$LOG_FILE"
log_msg "🚀 Aguardando boot..."

until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 5
done
sleep 10

log_msg "✅ Aplicando otimizações de sistema..."

{
    # 1. Liberar Limites Térmicos da MediaTek (PPM)
    # Garante que a CPU não sofra throttling agressivo na GSI
    if [ -d "/proc/ppm/policy" ]; then
        echo "0 0" > /proc/ppm/policy/thermal_limit
        echo "1" > /proc/ppm/policy/profile_on
        log_msg "PPM: Thermal Limit OFF / Profile ON"
    fi

    # 2. Otimização de GPU (Sem forçar Clock instável)
    # focado em manter o governor em performance e remover V-Sync
    M_PATH="/sys/devices/platform/13040000.mali/devfreq/13040000.mali"
    if [ -f "$M_PATH/governor" ]; then
        echo "performance" > "$M_PATH/governor"
        log_msg "Mali Gov: Performance"
    fi

    # 3. Tweaks de Renderização e Latência
    # Remove o limite de sincronia vertical e força GPU para composição
    setprop debug.egl.swapinterval 0
    service call SurfaceFlinger 1008 i32 1
    log_msg "V-Sync: OFF / HW Overlays: Disabled"

    # 4. Tweak de Resposta do Touch (crDroid/GSI)
    setprop windowsmgr.max_events_per_sec 240
    log_msg "Touch Rate: 240Hz"

    # Verificação Final
    REAL_FREQ=$(cat "$M_PATH/cur_freq" 2>/dev/null || echo "N/A")
    log_msg "📊 STATUS: Clock atual em $REAL_FREQ Hz"

} >> "$LOG_FILE" 2>&1

log_msg "✅ Script finalizado com sucesso."
exit 0
