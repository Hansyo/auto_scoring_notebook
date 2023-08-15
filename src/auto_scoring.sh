#!/bin/bash
#
echo_usage () {
    echo "Usage: $0 [-fh] <target directory>"
	echo "Description:"
	# Japanese:フォルダ内のipynbファイルに含まれているassert文を実行し、結果をテキストファイルに出力する
	# Japanese:docker上で実行するため、docker-compose.ymlがあるディレクトリで実行すること
	echo "  Execute the assert statement contained in the ipynb file in the folder and output the result to a text file."
	echo "  Since it is executed on docker, execute it in the directory where docker-compose.yml exists."
	echo ""
    echo "Options:"
    echo "  -f: Remove converted file before convert all ipynb files to py files"
    echo "  -h: Show this help message"
    echo ""
    echo "Warning:"
    echo "  If the same file name has already been converted, it will be overwritten."
}

while (( $# > 0 ))
do
    case $1 in
        -f)
            FORCE=1
            ;;
        -h)
            echo_usage
            exit 0
            ;;
        -*)
            echo "invalid option"
            exit 1
            ;;
        *)
            if [[ -n "$ARG1" ]] && [[ -n "$ARG2" ]]; then
                echo "Too many arguments." 1>&2
                exit 1
            else
                ARG1="$1"
            fi
            ;;
    esac
    shift
done


if [[ -z "$ARG1" ]]; then
    echo "target directory is required." 1>&2
    exit 1
fi

# check $1 is directory and exists
# FIXME: Google Classroom APIを使用してダウンロードするコードを実行するように書き換える
# 現状は、生徒毎に分けられたディレクトリ内にipynbファイルが保存されているという前提で、動作している。
if [ ! -d "$ARG1" ]; then
    ehco "$ARG1 is not directory."
    exit 1
fi

dest_dir=$ARG1
output_dir="outputs"

if [[ -n "$FORCE" ]]; then
    force_option="-f"
else
    force_option=""
fi

find "$dest_dir" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r student; do
    echo "$student"
    docker-compose run --rm -T auto-scoring ./src/convert_ipynb_to_py.sh "$force_option" "$student"
done

docker-compose run --rm -T auto-scoring ./src/check_assert.sh "$output_dir"
