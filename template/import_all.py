import glob
import os

# 現在のディレクトリを取得
current_directory = os.path.dirname(__file__)

# ディレクトリ内のすべての .py ファイルを検索
py_files = glob.glob(os.path.join(current_directory, "*.py"))

# 各ファイルを import
for py_file in py_files:
    # ファイル名から拡張子を取り除いてモジュール名に変換
    module_name = os.path.splitext(os.path.basename(py_file))[0]

    # __init__.pyと自身は無視
    if module_name != "__init__" and module_name != "import_all":
        # モジュールを import
        try:
            module = __import__(module_name)
            print("Done: {0}".format(module_name))
        except AssertionError:
            print("AssertionError: {0}".format(module_name))
