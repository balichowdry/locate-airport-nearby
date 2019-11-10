//
//  AirportListModel.swift
//  AirportLocatorApp
//
//  Created by Bilal Sattar on 09/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Foundation

struct AirportListModel {
    
    var status    : String?
    var isSuccess : Bool?
    var results   : [AirportsList] = []
    
    
    mutating func parseAirportListResponse(response: Dictionary<String, Any>) {
        print(#function)
        print(response)
        
        if let status = response["status"] as? String, status == "OK" {
            self.isSuccess = true
            self.status = status
            
            if let List = response["results"] as? NSArray {
                for Item in List {
                    var airportsListData: AirportsList = AirportsList()
                    airportsListData.parseAirportList(airportListData: Item as! Dictionary<String, Any>)
                    results.append(airportsListData)
                }
            }
            
        } else {
            self.isSuccess = false
           
        }
    }
    
    static func build(_ dict: [String: AnyObject]) -> AirportListModel {
        var list = AirportListModel()
        list.parseAirportListResponse(response: dict)
        return list
    }
}


struct AirportsList {

    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var id: String = ""
    var name: String = ""
    
    mutating func parseAirportList(airportListData: Dictionary<String, Any>) {
        if let airportListDataResponse:Dictionary<String, Any> = airportListData["geometry"] as? Dictionary<String, Any>{
            
            if let locationResponse:Dictionary<String, Any> = airportListDataResponse["location"] as? Dictionary<String, Any>{
                
                if let latitude = locationResponse["lat"] as? Double {
                    self.latitude = latitude
                }
                
                if let longitude = locationResponse["lng"] as? Double {
                    self.longitude = longitude
                }
            }
        }
        
        if let id = airportListData["id"] as? String {
            self.id = id
        }
        
        if let name = airportListData["name"] as? String {
            self.name = name
        }
    }
}
