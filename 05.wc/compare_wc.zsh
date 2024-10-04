commands=(
  "### 単一ファイルを渡した場合"
  "wc        sample.txt"
  "./main.rb sample.txt"

  "### 複数ファイルを渡した場合"
  "wc        sample.txt sample.json"
  "./main.rb sample.txt sample.json"

  "### パイプで受け取る場合"
  "ls             -l | wc"
  "../04.ls/ls.rb -l | ./main.rb"

  "### 入力リダイレクトで受け取る場合"
  "wc        < ./main.rb"
  "./main.rb < ./main.rb"

  "### 単一オプション指定の場合"
  "wc        -l sample.json"
  "./main.rb -l sample.json"

  "wc        -w sample.json"
  "./main.rb -w sample.json"

  "wc        -c sample.json"
  "./main.rb -c sample.json"

  "### 複数オプション指定の場合"
  "wc        -lw  sample.json"
  "./main.rb -lw  sample.json"

  "wc        -wc  sample.json"
  "./main.rb -wc  sample.json"

  "wc        -cl  sample.json"
  "./main.rb -cl  sample.json"

  "### 3つすべてのオプション指定の場合"
  "wc        -lwc sample.json"
  "./main.rb -lwc sample.json"

  "### 存在しないファイルを含む場合"
  "wc        sample.txt not_exist_file sample.json"
  "./main.rb sample.txt not_exist_file sample.json"
)

for cmd in "${commands[@]}"; do
  if [[ "$cmd" == "###"* ]]; then
    echo ""
    echo "$cmd"
  else
    echo "\$ $cmd"
    eval "$cmd"
  fi
done