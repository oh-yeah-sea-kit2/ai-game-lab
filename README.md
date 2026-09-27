# AIゲーム工房

Kindle本「AIゲーム工房」シリーズで作った Godot 4.6 のゲームを、ブラウザで無料で遊べるように公開するサイト。
https://oh-yeah-sea-kit2.github.io/ai-game-lab/

- `engine/` … Godot のエンジン本体（全ゲーム共通。1つだけ置いてサイト容量を抑える）
- `game-NN-*/` … 各ゲームのデータ（index.html・index.pck）
- 組み立ては kindle-engine の `tools/game_publish.py <slug>`、検査は `./scripts/check.sh`
