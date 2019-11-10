//
//  APICallManager.swift
//  CurrencyConverterApp
//
//  Created by Bilal Sattar on 02/09/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Foundation

// TODO: Setup Keys in Configuration
let BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/"
let key = "AIzaSyB0-dSS-Lyybta7f5-*********" // Use your own Key please

class NetworkManager {
    static let instance = NetworkManager()
    
    enum RequestMethod {
        case get
        case post
    }
    
    // MARK: Get Airport List
    func getAirportlist(lat:String, lng:String, onSuccess success: ((_ list: AirportListModel) -> Void)?, onFailure failure: ((_ errorMessage: String) -> Void)?) {
        let airportListHeaders = ["Content-Type": "application/json"]
        guard let url = buildURL(lat: lat, lng: lng) else {
            return;
        }
        
        self.setupRequest(
            url, method: .get, headers: airportListHeaders, params: nil,
            onSuccess: {(responseObject: JSON) -> Void in
                if let responseDict = responseObject.dictionaryObject {
                    let listDict = responseDict as [String : AnyObject]
                    let data =  AirportListModel.build(listDict)
                    
                    success?(data)
                } else {
                    failure?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failure?(errorMessage)
        }
        )
    }
    
    func buildURL(lat:String, lng:String) -> String? {
        let url = BASE_URL + "json?location=" + lat + "," + lng + "&radius=100000&keyword=airport&key=" + key
        return url
    }
    
    // MARK: Setup Request
    func setupRequest(
        _ url: String,
        method: HTTPMethod,
        headers: [String: String]?,
        params: Parameters? = nil,
        onSuccess success: ((JSON) -> Void)?,
        onFailure failure: ((String) -> Void)?
    ) {
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                success?(json)
            case .failure(let error):
                if let failure = failure {
                    failure(error.localizedDescription)
                }
            }
        }
    }
}
