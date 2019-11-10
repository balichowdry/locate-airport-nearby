//
//  test.swift
//  AirportLocator
//
//  Created by Bilal Sattar on 09/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import UIKit

protocol MapViewDelegate: class {
    func onStartLoading()
    func onEndLoading()
    func onFailure(Message: String)
    func onSuccess(list: AirportListModel)
}
