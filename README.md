# README
SESハードバウンスチェッカー

# Requirements
- Ruby 2.6.4
- Rails 5.2.5
- ngrok 2.3.40
- MySql 5.7

# 参考URL

### SES バウンス対策
- https://qiita.com/GoogIeSensei/items/063e8413dd3be868ce2d
- https://vitalify.jp/blog/2018/03/aws-ses-bouncemail.html

### 送信先が存在するかを事前にtelnet/MXレコードで調べる (精度や動作環境に問題あり。非推奨)
- https://qiita.com/yutackall/items/ce9285ecdf2f03db0404
- https://qiita.com/motty93/items/43de4df4e3c5f6bb43fc
- https://github.com/kurochan/mail-address-checker/blob/master/mail-address-checker.rb
- https://qiita.com/Shinguin/items/c63070c6e4b0e5ff6bf6
- https://kurochan-note.hatenablog.jp/entry/2014/02/17/172139
- https://www.t3a.jp/blog/web-develop/telnet-check-mailaddress/

### SESで送ってしまい、それの結果を取得する方法(with Amazon SNS)
- https://qiita.com/KeijiYONEDA/items/5e810d1f07392ab51d22
- http://program-memo.com/archives/599
- https://vitalify.jp/blog/2018/03/aws-ses-bouncemail.html
- https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/send-email-simulator.html
- https://docs.aws.amazon.com/ja_jp/sns/latest/dg/sns-message-and-json-formats.html
- https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/notification-contents.html
- https://qiita.com/jkr_2255/items/c1f24b3a09d3b06aa6ab
- https://qiita.com/afukuma/items/eebbefcb3033bb005317
  

### 無限ループに注意

- 参考: https://qiita.com/tbpgr/items/989c6badefff69377da7
- SESのFeedbackはDisabledにすること

1. 送付先アドレス入力
2. 送信ボタン押下
3. 送信先へメール送信した結果、
    1. 送信できた(Delivery)の場合 
        * 正常送信完了メールを特定アドレスに送付
    2. 送信不能(Bounce)の場合
        * バウンス通知メールを特定アドレスに送付

するが、
正常送信完了メールと、バウンス通知メールそれぞれが、SES側から見ると「送信先」となってしまい、1.送信できたの場合に入ってしまい、無限ループ発生してしまう。

なので、送信先が特定のアドレス（確実に届くことがわかっているアドレス）や、すでに正常送信完了メールもしくはバウンス通知メールを送ったものである場合は、送信判定と特定アドレスへのメール送付をしないようにしている。

