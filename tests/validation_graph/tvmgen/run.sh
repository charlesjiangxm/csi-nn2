#!/bin/sh -ex

backend="${1:-${TVMGEN_BACKEND:-c906}}"
qemu_bin="${QEMU:-qemu-riscv64}"

case "${backend}" in
    c906)
        cpu="c906fdv"
        ;;
    rvm|rvm_elf)
        cpu="c907fdvm,rlen=128"
        ;;
    *)
        echo "Unsupported tvmgen backend: ${backend}" >&2
        exit 1
        ;;
esac

"${qemu_bin}" -cpu "${cpu}" ./reg.o.elf
"${qemu_bin}" -cpu "${cpu}" ./callback.o.elf
