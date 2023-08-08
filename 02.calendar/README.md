# README
`cal`コマンドの模倣です。

ただし、単月表示のみであり、複数月の表示(e.g. `cal -3`)には対応していません。

## 使い方

```
$ ./cal.rb --help
  Displays a one-month calendar. This tool is like the `cal` command but with some differences:
    1. Only one month can be displayed at a time; multiple months' display is not supported.
    2. Output text is in English only.

  Examples
    ./cal.rb                         Display the current month's calendar
    ./cal.rb -m 8                    Display the calendar for current year
    ./cal.rb -m 8 -y 2024            Display the calendar for August 2024

  Options:
    -m, --month MONTH                Display the specified month
    -y, --year YEAR                  Display the specified year
    -h                               Turns off highlighting of today
    -j                               Display Julian days (days one-based, numbered from January 1)
    -N                               Display ncal mode
```


## サンプル
動作を確認している環境は次のとおりです。

```sh
$ sw_vers
ProductName:		macOS
ProductVersion:		13.5
BuildVersion:		22G74

# 実行時の年月に関係する機能があるので日付を確かめる
$ date "+%Y-%m-%d"
2023-08-08

$ echo $LANG
en_US.UTF-8
```

### 必須要件

#### 引数を指定しない場合は、今月・今年のカレンダーを表示する

```sh
$ cal
    August 2023
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30 31

$ ./cal.rb
    August 2023
Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30 31

```

#### `-m`で月を、`-y`で年を指定できる

```sh
$ cal -m 11
   November 2023
Su Mo Tu We Th Fr Sa
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30

$ ./cal.rb -m 11
   November 2023
Su Mo Tu We Th Fr Sa
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30

```

```sh
$ cal -m 11 2020
   November 2020
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30

$ ./cal.rb -y 2020 -m 11
   November 2020
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30

```

### 歓迎要件

#### `-N`: 月曜始まりにした上で転置で表示する(`ncal`モード)

```sh
$ cal -N
    August 2023
Mo     7 14 21 28
Tu  1  8 15 22 29
We  2  9 16 23 30
Th  3 10 17 24 31
Fr  4 11 18 25
Sa  5 12 19 26
Su  6 13 20 27
$ ./cal.rb -N
    August 2023
Mo     7 14 21 28
Tu  1  8 15 22 29
We  2  9 16 23 30
Th  3 10 17 24 31
Fr  4 11 18 25
Sa  5 12 19 26
Su  6 13 20 27
```

#### `-j`: ユリウス暦で表示する

```sh
$ cal -j -m 8 2023
        August 2023
 Su  Mo  Tu  We  Th  Fr  Sa
        213 214 215 216 217
218 219 220 221 222 223 224
225 226 227 228 229 230 231
232 233 234 235 236 237 238
239 240 241 242 243

$ ./cal.rb -j -m 8 -y 2023
        August 2023
 Su  Mo  Tu  We  Th  Fr  Sa
        213 214 215 216 217
218 219 220 221 222 223 224
225 226 227 228 229 230 231
232 233 234 235 236 237 238
239 240 241 242 243

```

#### 今日の日付の部分の色が反転する(背景色と文字色が入れ替わる)

<img alt="highlight_current_date.png" height="480" src="img/highlight_current_date.png"/>


#### `-h`: ハイライトをOFFにできる

<img alt="not_highlight_current_date" height="480" src="img/not_highlight_current_date.png"/>

#### 誤ったoptionを設定した場合にはエラーメッセージを表示する

```sh
$ ./cal.rb -x
invalid option: -x
  Displays a one-month calendar. This tool is like the `cal` command but with some differences:
    1. Only one month can be displayed at a time; multiple months' display is not supported.
    2. Output text is in English only.

  Examples
    mycal                            Display the current month's calendar
    mycal -m 8                       Display the calendar for current year
    mycal -m 8 -y 2024               Display the calendar for August 2024

  Options:
    -m, --month MONTH                Display the specified month
    -y, --year YEAR                  Display the specified year
    -h                               Turns off highlighting of today
    -j                               Display Julian days (days one-based, numbered from January 1)
    -N                               Display ncal mode
```

```sh
$ ./cal.rb -m 0
0 is not in range (1..12)

$ ./cal.rb -m 13
13 is not in range (1..12)

$ ./cal.rb -y 1969
1969 is not in range (1970..2100)

$ ./cal.rb -y 2101
2101 is not in range (1970..2100)
```


