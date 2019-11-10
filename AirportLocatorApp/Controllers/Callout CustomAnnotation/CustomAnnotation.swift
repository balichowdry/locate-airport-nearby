//
//  CustomAnnotation.swift
//  AirportLocator
//
//  Created by Bilal Sattar on 10/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Foundation
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}
