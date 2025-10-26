//
//  TiPOIItem.swift
//  TiGooglemaps
//
//  Created by Hans Knöchel on 26.10.25.
//

import Foundation
import CoreLocation
import UIKit
import GoogleMapsUtils

@objcMembers
class TiPOIItem: NSObject, GMUClusterItem {
  let position: CLLocationCoordinate2D
  var title: String?
  let subtitle: String?
  let icon: UIImage?
  let userData: [AnyHashable: Any]?
  
  @objc(initWithPosition:andTitle:subtitle:icon:userData:)
  init(position: CLLocationCoordinate2D,
       andTitle title: String?,
       subtitle: String?,
       icon: UIImage?,
       userData: [AnyHashable: Any]?) {
    self.position = position
    self.title = title
    self.subtitle = subtitle
    self.icon = icon
    self.userData = userData
    
    super.init()
  }
}
