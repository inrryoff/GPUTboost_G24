DEVICE=$(getprop ro.product.device)

case "$DEVICE" in
    fogorow)
        ui_print "✔ Moto G24 detectado!"
    ;;
    *)
        ui_print "❌ Apenas Moto G24 suportado!"
        abort
    ;;
esac
