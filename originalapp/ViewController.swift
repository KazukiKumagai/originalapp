//
//  ViewController.swift
//  originalapp
//
//  Created by 熊谷一騎 on 2017/03/26.
//  Copyright © 2017 熊谷一騎. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Alamofire
import SwiftyJSON

class ViewController: JSQMessagesViewController {
    
    var messages: [JSQMessage]?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自分のsenderId, senderDisokayNameを設定
        self.senderId = "user1"
        self.senderDisplayName = "hoge"
        
        //吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        //アバターの設定
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user")!, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user")!, diameter: 64)
        
        //メッセージデータの配列を初期化
        self.messages = []
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sendボタンが押された時に呼ばれる
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //新しいメッセージデータを追加する
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.messages?.append(message!)
        
        //メッセジの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessage(animated: true)
        
        //擬似的に自動でメッセージを受信
        self.receiveAutoMessage()
        self.test()
    }
    
    //アイテムごとに参照するメッセージデータを返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages?[indexPath.item]
    }
    
    //アイテムごとのMessageBubble(背景)を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    //アイテムごとにアバター画像を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    
    //アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages?.count)!
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
    }
    
    //返信メッセージを受信する
    func receiveAutoMessage() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.didFinishMessageTimer(sender:)), userInfo: nil, repeats: false)
    }
    
    func didFinishMessageTimer(sender: Timer) {
        let message = JSQMessage(senderId: "user2", displayName: "underscore", text: "Hello!")
        self.messages?.append(message!)
        self.finishReceivingMessage(animated: true)
    }
    
    
    func test(){
        //func getWeatherByLL(longitude:Float, latitude:Float) {
        //let url:String = "https://map.yahooapis.jp/weather/V1/place?coordinates=" + String("\(longitude)") + "," + String("\(latitude)")
        
        Alamofire.request("https://map.yahooapis.jp/weather/V1/place?coordinates=139.732293,35.663613&appid=dj0zaiZpPW5nTVJsMUFYcUZZZyZzPWNvbnN1bWVyc2VjcmV0Jng9ZWM-&output=json").responseJSON { response in
            
            // レスポンス処理開始ログ
            print("=============== API response manage start ===============")
            
            //            print(response.request)  // original URL request
            //            print(response.response) // HTTP URL response
            //            print(response.data)     // server data
            //            print(response.result)   // result of response serialization

            // alamofireエラーハンドリング
            switch response.result {
            case .success(let object):
                // JSONオブジェクト生成
                let json = JSON(object)
                json.forEach { (_, json) in
                    
                    // ステータス
                    if let status = json["Status"].string {
                        print("API Response status: \(status)")
                    }
                    
                    // ひとまずJSON中身開示
                    print("json description: \(json)")
                    
                    json.arrayValue.forEach{ (obj) in
                        
                        /*
                         本来ならここで展開すると同時にModelを作成しておくべき
                         */
                        
                        print("obj: \(obj)")
                        // Name取得
                        if let name = obj["Name"].string {
                            // 名前(name)取得
                            print("Name: \(name)")
                            
                            if let nameMessage = JSQMessage(senderId: "test-doi", displayName: "テスト土井君", text: "名前は\n\(name)\nやがな！") {
                                self.messages?.append(nameMessage)
                                self.finishReceivingMessage()
                            }
                        } else {
                            // ない場合は処理飛ばし
                            print("名前とれへんがな！")
                        }
                        
                        // whether展開処理
                        obj["Property"].dictionaryValue["WeatherList"]?.dictionaryValue["Weather"]?.arrayValue.forEach{ (weather) in
                            print("Weather: \(weather)")
                            if let rainFall = weather["Rainfall"].int, let date = weather["Date"].string {
                                print("\(date)の雨の確率\(rainFall)やがな！")
                                if let nameMessage = JSQMessage(senderId: "test-doi", displayName: "テスト土井君", text: "\(date)の雨の確率\(rainFall)やがな！") {
                                    self.messages?.append(nameMessage)
                                    self.finishReceivingMessage()
                                }
                                
                            } else {
                                print("雨の確率わからんがな！")
                            }
                        }
                        
                    }
                    
                }
            case .failure(let error):
                print("ERROR: \(error)")
            }
            
            // レスポンス処理終了ログ
            print("=============== API response manage end ===============")
        }
    }
    
}
