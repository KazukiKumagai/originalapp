# originalapp
## 概要
ユーザから得られた情報を元に、ドライブポイントを提供するチャットボット。

※ドライブポイント提供のアルゴリズムは非常に簡単なものとする

### チャットボットに必要な入力情報
以下の情報を元に出力(ドライブポイント)を決定する。
- ユーザからの入力情報
    - 移動時間
    - 乗り物(車 or バイク)
    - ユーザの位置情報 (自動でユーザの位置情報が取れない場合)
- アプリ実装からの情報
    - 移動前後の天気 (外部API利用)
    - ドライブポイントDB (適当なドライブポイントの名前と位置情報で構成される)

### チャットボットから得られる出力情報
- 必要な入力情報を全て満たした際に以下を出力する。
    - 移動までの距離 (外部API利用)
    - 移動時間 (外部API利用)
    - 移動方法 (外部API利用)
- 必要な入力情報を満たさない場合は、必要な情報が得られるように聞き返す。

## 利用する外部APIについて
- 天気
- 地図
