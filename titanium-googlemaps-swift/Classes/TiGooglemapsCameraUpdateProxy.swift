/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import UIKit
import TitaniumKit
import GoogleMaps
import CoreLocation

@objc(TiGooglemapsCameraUpdateProxy)
public class TiGooglemapsCameraUpdateProxy: TiProxy {
  private var update: GMSCameraUpdate?
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  // MARK: - Public API
  
  @objc public func cameraUpdate() -> GMSCameraUpdate? {
    if update == nil {
      NSLog("[ERROR] Trying to receive a camera update that has no action specified. This will likely cause a crash.")
    }
    
    return update
  }
  
  @objc public func zoomIn(_ unused: Any?) {
    runOnMainThread {
      self.update = GMSCameraUpdate.zoomIn()
    }
  }
  
  @objc public func zoomOut(_ unused: Any?) {
    runOnMainThread {
      self.update = GMSCameraUpdate.zoomOut()
    }
  }
  
  @objc public func zoom(_ args: [Any]) {
    runOnMainThread {
      guard let value = args.first else { return }
      let zoomBy = CGFloat(TiUtils.floatValue(value))
      
      if args.count == 2 {
        let pointValue = TiUtils.pointValue(args[1])
        self.update = GMSCameraUpdate.zoom(by: Float(zoomBy), at: pointValue)
      } else {
        self.update = GMSCameraUpdate.zoom(by: Float(zoomBy))
      }
    }
  }
  
  @objc public func setTarget(_ args: [String: Any]) {
    runOnMainThread {
      guard let lat = args["latitude"], let lon = args["longitude"] else { return }
      let coordinate = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(lat), longitude: TiUtils.doubleValue(lon))
      
      if let zoomValue = args["zoom"] {
        self.update = GMSCameraUpdate.setTarget(coordinate, zoom: Float(TiUtils.floatValue(zoomValue)))
      } else {
        self.update = GMSCameraUpdate.setTarget(coordinate)
      }
    }
  }
  
  @objc public func setCamera(_ args: [String: Any]) {
    runOnMainThread {
      guard let latitude = args["latitude"],
            let longitude = args["longitude"],
            let zoom = args["zoom"],
            let bearing = args["bearing"],
            let viewingAngle = args["viewingAngle"] else {
        return
      }
      
      let target = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(latitude), longitude: TiUtils.doubleValue(longitude))
      let cameraPosition = GMSCameraPosition(target: target,
                                             zoom: Float(TiUtils.floatValue(zoom)),
                                             bearing: TiUtils.doubleValue(bearing),
                                             viewingAngle: TiUtils.doubleValue(viewingAngle))
      self.update = GMSCameraUpdate.setCamera(cameraPosition)
    }
  }
  
  @objc public func fitBounds(_ args: [String: Any]) {
    runOnMainThread {
      guard let boundsDict = args["bounds"] as? [String: Any],
            let coordinate1 = boundsDict["coordinate1"] as? [String: Any],
            let coordinate2 = boundsDict["coordinate2"] as? [String: Any] else {
        return
      }
      
      let coord1 = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(coordinate1["latitude"]),
                                          longitude: TiUtils.doubleValue(coordinate1["longitude"]))
      let coord2 = CLLocationCoordinate2D(latitude: TiUtils.doubleValue(coordinate2["latitude"]),
                                          longitude: TiUtils.doubleValue(coordinate2["longitude"]))
      
      let bounds = GMSCoordinateBounds(coordinate: coord1, coordinate: coord2)
      if args["padding"] != nil && args["insets"] != nil {
        NSLog("[ERROR] Cannot use both `padding` and `insets` in the `fitBounds` method. See Google Maps docs for details.")
        return
      }
      
      if let padding = args["padding"] {
        self.update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(TiUtils.floatValue(padding)))
        return
      }
      
      if let insets = args["insets"] {
        self.update = GMSCameraUpdate.fit(bounds, with: TiUtils.contentInsets(insets))
        return
      }
      
      self.update = GMSCameraUpdate.fit(bounds)
    }
  }
  
  @objc public func scrollBy(_ args: [String: Any]) {
    runOnMainThread {
      let x = CGFloat(TiUtils.floatValue(args["x"]))
      let y = CGFloat(TiUtils.floatValue(args["y"]))
      self.update = GMSCameraUpdate.scrollBy(x: CGFloat(x), y: CGFloat(y))
    }
  }
}
