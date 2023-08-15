# Auto scoring notebook

dockerを使って、notebookを自動採点します。

## 環境構築

```bash
cp .env.template .env
# .envが最適になるように編集して下さい。
docker-compose build
```

## 使い方

採点結果は、`outputs/<学生毎のディレクトリ>/<ディレクトリ名>_results.txt`に出力される。

### 1. そのまま使う or 追加で実行する場合

不要なファイルが含まれていない場合

```bash
./src/auto_scoring.sh downloads
```

### 2. 出力結果をリセットして実行し直す場合

不要なファイルが含まれている場合

```bash
./src/auto_scoring.sh downloads
```
