//
//  AppConfiguration.swift
//  AirportLocator
//
//  Created by Bilal Sattar on 10/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import Foundation

// TODO: Setup Keys in Configuration
class AppConfiguration: NSObject {
@objc static let sharedInstance = AppConfiguration()

fileprivate var savedDictionary: Dictionary<String, Any>?

private override init() {}

var productionGoogleApiKey: String {
  let dict = appConfigurationDictionary()
  return dict["api-key-production"] as! String
}

fileprivate func appConfigurationDictionary() -> Dictionary<String, Any> {
  guard let dict = savedDictionary else {
  let plistName = Bundle.main.object(forInfoDictionaryKey: "app-configuration") as! String
  
  if let path = Bundle.main.path(forResource: plistName, ofType: "plist"), !plistName.isEmpty {
    savedDictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String, Any>
  } else {
    assert(false, "app configuration plist does not exist")
  }
  
    return savedDictionary!
  }
  
  return dict
}

}

