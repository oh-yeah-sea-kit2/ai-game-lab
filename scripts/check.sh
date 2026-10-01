#!/bin/bash
# 公開サイトの検査: エンジンがそろい、各ゲームに index.html・index.pck があり、エンジンを ../engine から読む
set -euo pipefail
cd "$(dirname "$0")/.."
for f in index.wasm index.js index.audio.worklet.js index.audio.position.worklet.js; do
  [ -s "engine/$f" ] || { echo "NG engine/$f が無い"; exit 1; }
done
n=0
for d in game-*/; do
  d="${d%/}"
  [ -s "$d/index.html" ] && [ -s "$d/index.pck" ] || { echo "NG $d に index.html か index.pck が無い"; exit 1; }
  grep -q '"executable": "../engine/index"' "$d/index.html" || { echo "NG $d がエンジンを ../engine から読んでいない"; exit 1; }
  grep -q '"mainPack": "index.pck"' "$d/index.html" || { echo "NG $d の mainPack"; exit 1; }
  n=$((n+1))
done
[ "$n" -ge 1 ] || { echo "NG ゲームが1本も無い"; exit 1; }
size=$(( $(find "$PWD" -path "$PWD/.git" -prune -o -type f -print0 | xargs -0 cat | wc -c) / 1024 ))
echo "OK games=$n size_kb=$size"
[ "$size" -lt 900000 ] || { echo "NG サイトが 900MB を超えた（Pages の上限 1GB）"; exit 1; }
# 配布 ZIP にフォルダ項目があるか（無いとブラウザ版 Godot が中のファイルを展開できない。2026-10-02 実測）
for z in game-*/source.zip; do
  [ -e "$z" ] || continue
  python3 -c "import zipfile,sys;n=zipfile.ZipFile(sys.argv[1]).namelist();sys.exit(0 if any(x.endswith('/') for x in n) else 1)" "$z" || { echo "NG $z にフォルダ項目が無い"; exit 1; }
done
echo "OK source.zip にフォルダ項目あり"
