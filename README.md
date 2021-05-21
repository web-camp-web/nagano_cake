#  ECサイト「長野ケーキ」

DMMWEBCAMPのチーム開発課題で作成しました。  
20代後半〜40代の大人の女性をターゲットとし、
高級感のあるデザインとなっています。

# アプリケーション設計
## テーブル定義書
[こちら](https://docs.google.com/spreadsheets/d/1O7NMBC0LyCQ3NQarhvakCtur5A0rcf-RoBIvrxzBXkM/edit?usp=sharing)よりご覧ください

## ER図
![image](https://user-images.githubusercontent.com/78312000/119122111-229d5200-ba69-11eb-8722-119ac1c7e103.png)

## アプリケーション詳細設計図

<img width="567" alt="admin" src="https://user-images.githubusercontent.com/78312000/119119428-254a7800-ba66-11eb-938e-21dad4855472.png">

<img width="610" alt="customer" src="https://user-images.githubusercontent.com/78312000/119121828-d7833f00-ba68-11eb-93c9-a7b4925e9281.png">

# 機能
## 管理者側

管理者の機能は以下の通りです。  
1.管理者用メールアドレスとパスワードでのログイン  
2.商品の新規追加、情報編集、販売停止状態への切り替え  
3.顧客情報の閲覧、編集、退会状態への切り替え  
4.注文ステータスと、商品の製作ステータスの切り替え

## 顧客側

顧客の機能は以下の通りです。  
1.顧客ユーザ登録、ログイン、ログアウト  
2.自身の配送先登録と編集  
3.自身の顧客情報編集  
4.商品一覧の閲覧(この機能のみログイン不要)  
5.商品をカートに入れる、個数変更、削除  
6.カート内商品の注文、詳細確認

# 開発環境

開発言語：Ruby  
IDE:Cloud9  
Ruby on Rails version5.2.5  
ImageMagick-7.0.11

# 開発者

たっつん・はま・マイク
