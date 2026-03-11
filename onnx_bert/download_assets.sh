#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly DRIVE_FOLDER_URL="https://drive.google.com/drive/folders/1ON39bq3IGAZss8q99WHMgfcI3541O6Wt?usp=sharing"
readonly ONNX_FILE_ID="1Cp0X6mvrY9FGbhjFszU-5pWP_y4t_SdK"
readonly PARAM_FILE_ID="1c1eXL2deaH2wJYyEgmN7Kns-1R6tgrU_"

usage() {
    cat <<EOF
Download the large onnx_bert assets from the shared Google Drive folder.

Usage:
  ./download_assets.sh [--dest DIR] [--force]

Options:
  --dest DIR   Download into DIR. Defaults to the onnx_bert directory.
  --force      Re-download files even if they already exist.
  -h, --help   Show this help text.

Source folder:
  ${DRIVE_FOLDER_URL}
EOF
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "error: required command '$1' is not available" >&2
        exit 1
    fi
}

validate_download() {
    python3 - "$1" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
if not path.exists() or path.stat().st_size == 0:
    raise SystemExit(f"error: {path} is missing or empty after download")

prefix = path.read_bytes()[:256].lstrip().lower()
if prefix.startswith(b"<!doctype html") or prefix.startswith(b"<html"):
    raise SystemExit(f"error: {path} looks like an HTML response instead of the requested asset")
PY
}

download_file() {
    local file_name="$1"
    local file_id="$2"
    local output_path="${DEST_DIR}/${file_name}"
    local tmp_path="${output_path}.part"
    local url="https://drive.usercontent.google.com/download?id=${file_id}&export=download&confirm=t"

    if [[ -s "${output_path}" && "${FORCE_DOWNLOAD}" -eq 0 ]]; then
        echo "Skipping ${file_name}; file already exists."
        return 0
    fi

    echo "Downloading ${file_name}..."
    rm -f "${tmp_path}"
    curl --fail --location --retry 3 --retry-delay 2 --output "${tmp_path}" "${url}"
    validate_download "${tmp_path}"
    mv "${tmp_path}" "${output_path}"
}

DEST_DIR="${SCRIPT_DIR}"
FORCE_DOWNLOAD=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dest)
            if [[ $# -lt 2 ]]; then
                echo "error: --dest requires a directory argument" >&2
                usage >&2
                exit 2
            fi
            DEST_DIR="$2"
            shift 2
            ;;
        --force)
            FORCE_DOWNLOAD=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument '$1'" >&2
            usage >&2
            exit 2
            ;;
    esac
done

require_cmd curl
require_cmd python3

mkdir -p "${DEST_DIR}"

download_file "bert_small_int32_input.onnx" "${ONNX_FILE_ID}"
download_file "model.params" "${PARAM_FILE_ID}"

echo "Downloaded onnx_bert assets into ${DEST_DIR}"
