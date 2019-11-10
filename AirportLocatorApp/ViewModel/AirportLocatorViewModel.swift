//
//  ALMapPresenter.swift
//  AirportLocatorApp
//
//  Created by Bilal Sattar on 01/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Foundation

final class AirportLocatorViewModel {
    private let airportLS:LocationService
    weak private var delegate : MapViewDelegate?
    
    init(airportLocationService:LocationService) {
        self.airportLS = airportLocationService
    }
    
    func register(view :MapViewDelegate) {
        delegate = view
    }
    
    func getAirportList(lat:String, lng:String) {
        self.delegate?.onStartLoading()
        airportLS.getAirportList(lat:lat, lng:lng,
            onSuccess: { (lists) in
                    self.delegate?.onEndLoading()
                    self.delegate?.onSuccess(list: lists)
        },
            onFailure: { (errorMessage) in
                    self.delegate?.onEndLoading()
                    self.delegate?.onFailure(Message: "failure message")
        })
    }
}
