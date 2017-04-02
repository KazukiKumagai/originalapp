//
//  Weather.swift
//  originalapp
//
//  Created by 熊谷一騎 on 2017/04/01.
//  Copyright © 2017 熊谷一騎. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let yahooAppID:String = "dj0zaiZpPW5nTVJsMUFYcUZZZyZzPWNvbnN1bWVyc2VjcmV0Jng9ZWM-"

class Weather {
    /*
    public struct JSON {
        public init(_ object: AnyObject){
            self.object = object
        }
    }
    */
    func test(){
    //func getWeatherByLL(longitude:Float, latitude:Float) {
        //let url:String = "https://map.yahooapis.jp/weather/V1/place?coordinates=" + String("\(longitude)") + "," + String("\(latitude)")
        
        Alamofire.request("https://map.yahooapis.jp/weather/V1/place?coordinates=139.732293,35.663613&appid=dj0zaiZpPW5nTVJsMUFYcUZZZyZzPWNvbnN1bWVyc2VjcmV0Jng9ZWM-&output=json").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            let json = JSON(response.result.value)
            if let dd = json["Items"].string {
                print(dd)
            }
        }
    }
    func getWeatherByPlace(place: String) {
    }
}

