//
//  TiGooglemapsModule.swift
//  titanium-googlemaps
//
//  Created by Your Name
//  Copyright (c) 2025 Your Company. All rights reserved.
//

import UIKit
import TitaniumKit
import GoogleMaps
import GooglePlaces

@objc(TiGooglemapsModule)
class TiGooglemapsModule: TiModule {
  
  func moduleGUID() -> String {
    return "a599acf0-6c26-4190-965d-b3f8ca5b32de"
  }
  
  override func moduleId() -> String! {
    return "ti.googlemaps"
  }
  
  @objc(sdkVersion:)
  func sdkVersion(unused: Any?) -> String {
    return GMSServices.sdkVersion()
  }

  @objc(setAPIKey:)
  func setAPIKey(arguments: [Any]) {
    guard let apiKey = arguments.first as? String else {
      return
    }
    
    GMSServices.provideAPIKey(apiKey)
  }
}
