#!/bin/bash

echo_usage () {
    echo "Usage: $0 [-fh] <target directory>"
    echo "Options:"
    echo "  -f: Remove converted file before convert all ipynb files to py files"
    echo "  -h: Show this help message"
    echo ""
    echo "Warning:"
    echo "  If the same file has already been converted, it will be overwritten."
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
            if [[ -n "$ARG1" ]]; then
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
    echo "'arg1' is required." 1>&2
    exit 1
fi

if [ ! -d "$ARG1" ]; then
    echo "$ARG1 is not directory."
    exit 1
fi

dest_dir=$ARG1
output_dir="outputs/$(basename "$ARG1")"

# NOTE: ローカル環境でスクリプトを確認するため、PROJECT_ROOT環境変数が設定されていない場合はgitのルートディレクトリを設定する
if [[ -z "$PROJECT_ROOT" ]]; then
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
fi

if [[ -n "$FORCE" || -e $output_dir ]]; then
    rm -rf "$output_dir/*.py" "$output_dir/*.ipynb"
fi

if [[ -n "$FORCE" || ! -e $output_dir ]]; then
    mkdir -p "$output_dir"
    if [[ -n "$FORCE" || ! -e "$output_dir/import_all.py" ]]; then
        cp -f "$PROJECT_ROOT/template/import_all.py" "$output_dir"
    fi
fi

# Convert all ipynb files in the $1 directory to py files on $output_dir
for file in "$dest_dir"/*.ipynb; do
    echo "Converting $file"
    if [[ -n "$FORCE" || ! -e "$output_dir/${file%.*}.py" ]]; then
        jupyter nbconvert --to script "$file" --output-dir "$output_dir"
        if [[ -e "$output_dir/$(basename "${file%.*}").txt" ]]; then
            # nbconvertがtxt形式でファイルを出力することがあるので、pythonに変換する
            mv -f "$output_dir/$(basename "${file%.*}").txt" "$output_dir/$(basename "${file%.*}").py"
        fi
    fi
done
