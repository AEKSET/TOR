#!/bin/bash
# convert_docx_to_md.sh
# แปลงไฟล์ .docx/.DOC ใน templates/ เป็น .md ใน reference/
# ต้องติดตั้ง pandoc ก่อน: https://pandoc.org/installing.html

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"   # หนึ่งระดับเหนือ dev/

TEMPLATES_DIR="$ROOT/templates"
REFERENCE_DIR="$ROOT/reference"

echo "======================================"
echo " DOCX → Markdown Converter"
echo " Input : $TEMPLATES_DIR"
echo " Output: $REFERENCE_DIR"
echo "======================================"

# หา pandoc — ลอง PATH ก่อน ถ้าไม่เจอลอง AppData
PANDOC="pandoc"
if ! command -v pandoc &> /dev/null; then
    if [[ -f "$USERPROFILE/AppData/Local/Pandoc/pandoc.exe" ]]; then
        PANDOC="$USERPROFILE/AppData/Local/Pandoc/pandoc.exe"
    elif [[ -f "/c/Users/AEKKARAT/AppData/Local/Pandoc/pandoc.exe" ]]; then
        PANDOC="/c/Users/AEKKARAT/AppData/Local/Pandoc/pandoc.exe"
    else
        echo ""
        echo "ERROR: ไม่พบ pandoc กรุณาติดตั้งก่อน"
        echo "  ดาวน์โหลด: https://pandoc.org/installing.html"
        echo "  หรือใช้ winget: winget install JohnMacFarlane.Pandoc"
        exit 1
    fi
fi

echo "pandoc version: $($PANDOC --version | head -1)"
echo ""

TOTAL=0
CONVERTED=0
SKIPPED=0
FAILED=0

# หาไฟล์ .docx และ .DOC ทั้งหมดใน templates/
while IFS= read -r -d '' DOCX_FILE; do
    # ข้าม ~$ temp files
    if [[ "$(basename "$DOCX_FILE")" == ~\$* ]]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))

    # ตรวจว่าอยู่ใน subfolder ไหน (tor / sow / contract)
    REL_TO_TEMPLATES="${DOCX_FILE#$TEMPLATES_DIR/}"   # เช่น tor/filename.docx
    SUBDIR="${REL_TO_TEMPLATES%%/*}"                   # เช่น tor
    BASENAME="$(basename "$DOCX_FILE")"
    SAFE_NAME="${BASENAME%.*}.md"                      # ตัด .docx/.DOC แล้วเพิ่ม .md

    OUT_DIR="$REFERENCE_DIR/$SUBDIR"
    mkdir -p "$OUT_DIR"
    MD_FILE="$OUT_DIR/$SAFE_NAME"

    # ข้ามถ้า MD ใหม่กว่า DOCX
    if [[ -f "$MD_FILE" ]] && [[ "$MD_FILE" -nt "$DOCX_FILE" ]]; then
        echo "  [SKIP] $REL_TO_TEMPLATES"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    echo -n "  [CONVERTING] $REL_TO_TEMPLATES → reference/$SUBDIR/$SAFE_NAME ... "

    # แปลง path เป็น Windows format สำหรับ pandoc.exe (รองรับ Thai characters)
    WIN_IN="$(cygpath -w "$DOCX_FILE" 2>/dev/null || echo "$DOCX_FILE")"
    WIN_OUT="$(cygpath -w "$MD_FILE" 2>/dev/null || echo "$MD_FILE")"
    WIN_MEDIA="$(cygpath -w "$OUT_DIR/media" 2>/dev/null || echo "$OUT_DIR/media")"

    if "$PANDOC" "$WIN_IN" \
        --from=docx \
        --to=markdown \
        --wrap=none \
        --extract-media="$WIN_MEDIA" \
        -o "$WIN_OUT" 2>/dev/null; then
        echo "OK"
        CONVERTED=$((CONVERTED + 1))
    else
        echo "FAILED"
        FAILED=$((FAILED + 1))
        rm -f "$MD_FILE"
    fi

done < <(find "$TEMPLATES_DIR" \( -iname "*.docx" -o -iname "*.doc" \) -not -path "*/.git/*" -print0)

echo ""
echo "======================================"
echo " สรุป:"
echo "   ไฟล์ทั้งหมด : $TOTAL"
echo "   แปลงสำเร็จ  : $CONVERTED"
echo "   ข้าม (มีแล้ว): $SKIPPED"
echo "   ล้มเหลว     : $FAILED"
echo "======================================"
echo ""
echo "ไฟล์ .md ทั้งหมดอยู่ใน: $REFERENCE_DIR/"
