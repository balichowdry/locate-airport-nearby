//
//  ALMapService.swift
//  AirportLocatorApp
//
//  Created by Bilal Sattar on 01/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Foundation

final class LocationService {
    public func getAirportList (lat:String,lng:String,onSuccess success: ((_ list: AirportListModel) -> Void)?, onFailure failure: ((_ errorMessage: String) -> Void)?) {
        NetworkManager.instance.getAirportlist(lat:lat,lng:lng,
            onSuccess: { (airports) in
                success?(airports)
        },
            onFailure: { (errorMessage) in
                failure?(errorMessage)
        })
    }
}
