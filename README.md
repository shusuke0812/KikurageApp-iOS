Kikurage Cultivation App  
===

## What is Kikurage ?
Wood ear which is kind of mushroom is called `Kikurage` in Japanese.

## Story
In 2018 summer, we participated Startup Weekend in Tokyo.  
Developers who like Kikurage made an IoT product, this won a third prize in this event with 12 teams. After that, we challenged Crowdfunding and [GUGEN](https://gugen.jp/). Now on continuing to develop.

## Summary
Moblie App parts of this IoT product can be monitoring and observing to Kikurage cultivation state. This app use with [Kikurage cultivatuion kits](https://www.midorikoubou.jp/shopdetail/000000000007/).

![devices](https://user-images.githubusercontent.com/33107697/160163230-b7ed139a-3d9d-4802-b131-272959902e08.png)

### IoT system
![iot_system](https://user-images.githubusercontent.com/33107697/160153702-cb5e7b65-3795-4dfe-8902-1a273e7d30ae.png)

### Technologies in use

|  Keywords  |  Status  |
| :--- | :---- |
|  Bluetooth  |  [DONE](https://github.com/shusuke0812/KikurageApp-iOS/tree/develop/KikurageFeature/Bluetooth)  |
|  NFC  |  In-progress  |
|  Firebase Firestore  |  DONE  |
|  Firebase Storage  |  DONE  |
|  Firebase Authentication  |  DONE  |
|  TwitterAPI  |  DONE  |
|  RxSwift  |  DONE  |
|  QR code reader  |  [DONE](https://github.com/shusuke0812/KikurageApp-iOS/tree/develop/KikurageFeature/QRCodeReader)  |
|  Logger  |  [DONE](https://github.com/shusuke0812/KikurageApp-iOS/tree/develop/KikurageFeature/Logger)  |

<br />

![ui](https://user-images.githubusercontent.com/33107697/160155691-1730da8b-0ea7-4f0b-b703-7790fc54d552.png)

## Development
- Xcode 15.0 (15A240d)
- Swift 5.6 
- CocoaPods 1.13.0  
- MacOS Ventura 13.0 / MacBook Arm Processor Model
- Target OS：iOS 14.0 

## Author
- [@shusuke0812](https://github.com/shusuke0812)

## License

The author do not take any responsibility for your using this sorce. For more information see our full [license](https://github.com/shusuke0812/KikurageApp-iOS/blob/develop/LICENSE).


<br>

<details>
<summary><b>In Japanese</b></summary>
<div>

<br>

## 背景
きっかけは2018年の夏に行われたStartup Weekendというイベント。  
きくらげ好きなエンジニアが週末３日間で考えた本プロダクトがイベントで12チーム中3位になり、その後もGUGENやクラウドファンディングに挑戦。  
現在も個人開発をちょっとずつ進めている。  
　  
## 概要
本アプリは、家庭で きくらげ を育てることができる[きくらげ栽培キット](https://www.midorikoubou.jp/shopdetail/000000000007/)と一緒に使うことを想定した、  
きくらげ栽培環境のモニタリング・生育の観察記録機能を備える

## 狙い
- きくらげの家庭栽培を通して国内の農業従事者を増やすことである。子供の時から農産物を育てることに興味を持ってもらい、この課題を解決することが狙いである。
- 市場流通量が10%にも満たない栄養価も高く歯応えの良い純国産きくらげの生産を増やすことにも貢献できたらと考えている。
　
## 説明
**【デバイス】**  
ターゲット：小学校低学年〜高学年の男女  
利用シーン：夏休みの自由研究  
狙い　　　：子供の「健康に対する意識」「能動的に学ぶ力」「食への感謝の気持ち」を醸成し、農業に興味を持ってもらう  
コンセプト：大人も子供も手軽に２週間で楽しめるきくらげ栽培自由研究  


![main](https://user-images.githubusercontent.com/33107697/147388647-d4c4e01c-bebe-4b50-a5ce-085fe798f7a0.png)



**【アプリ主要機能】**  
１.きくらげ栽培環境の良し悪しをリアルタイムで見れる  
２.きくらげ栽培の観察記録（写真・コメント・日付・温度湿度グラフ）が取れる  
３.きくらげ栽培者同士で相談ができる（現在はFacebookグループのリンクを貼っているだけ）  


![UI](https://user-images.githubusercontent.com/33107697/147388903-2843b851-8d7d-45d6-b3c3-1531cc441c73.png)

## IoTシステム概要
![system](https://user-images.githubusercontent.com/33107697/147388919-75406b53-610b-4760-a622-d219d019acbe.png)

## 開発環境
- Xcode 15.0 (15A240d)
- Swift 5.6 
- CocoaPods 1.13.0  
- MacOS Ventura 13.0 / MacBook Arm Processor Model
- Target OS：iOS 14.0  

## 参考文献
- Swift
  - [Heart of Swift](https://heart-of-swift.github.io/)
  - [Swift API Guidelines](https://www.swift.org/documentation/api-design-guidelines/#strive-for-fluent-usage)
  - [Logging: WWDC2020](https://developer.apple.com/videos/play/wwdc2020/10168/)

## 著者
- [@shusuke0812](https://github.com/shusuke0812)

## その他
- [コードレビュー内容](https://www.notion.so/KikurageApp-iOS-1c008377610146a382225e0b4b2ad47e)

</div>
</details>
