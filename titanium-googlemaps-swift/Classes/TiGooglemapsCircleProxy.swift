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

@objc(TiGooglemapsCircleProxy)
public class TiGooglemapsCircleProxy: TiProxy {
  private var circleInternal: GMSCircle?
  
  private var circleInstance: GMSCircle {
    if let circle = circleInternal {
      return circle
    }
    
    let circle = GMSCircle()
    circle.isTappable = true
    circleInternal = circle
    return circle
  }
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func coordinate(from value: Any?) -> CLLocationCoordinate2D? {
    if let dict = value as? [String: Any] {
      let latitude = TiUtils.doubleValue(dict["latitude"])
      let longitude = TiUtils.doubleValue(dict["longitude"])
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    } else if let array = value as? [Any], array.count >= 2 {
      let latitude = TiUtils.doubleValue(array[1])
      let longitude = TiUtils.doubleValue(array[0])
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    return nil
  }
  
  // MARK: - Public API
  
  @objc public func circle() -> GMSCircle {
    return circleInstance
  }
  
  @objc public func setCenter(_ value: Any?) {
    runOnMainThread {
      guard let coordinate = self.coordinate(from: value) else {
        NSLog("[WARN] Ti.GoogleMaps: You need to specify the center either using an array or object.")
        return
      }
      
      self.circleInstance.position = coordinate
      self.replaceValue(value ?? NSNull(), forKey: "center", notification: false)
    }
  }
  
  @objc public func setRadius(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.radius = TiUtils.doubleValue(value)
      self.replaceValue(value, forKey: "radius", notification: false)
    }
  }
  
  @objc public func setTappable(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.isTappable = TiUtils.boolValue(value)
      self.replaceValue(value, forKey: "tappable", notification: false)
    }
  }
  
  @objc public func setFillColor(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.fillColor = TiUtils.colorValue(value)?.color
      self.replaceValue(value, forKey: "fillColor", notification: false)
    }
  }
  
  @objc public func setStrokeColor(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.strokeColor = TiUtils.colorValue(value)?.color
      self.replaceValue(value, forKey: "strokeColor", notification: false)
    }
  }
  
  @objc public func setStrokeWidth(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.strokeWidth = CGFloat(TiUtils.floatValue(value, def: 1))
      self.replaceValue(value, forKey: "strokeWidth", notification: false)
    }
  }
  
  @objc public func setTitle(_ value: Any?) {
    runOnMainThread {
      let title = TiUtils.stringValue(value)
      self.circleInstance.title = title
      self.replaceValue(title ?? NSNull(), forKey: "title", notification: false)
    }
  }
  
  @objc public func setZIndex(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.zIndex = Int32(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "zIndex", notification: false)
    }
  }
  
  @objc public func setUserData(_ value: Any?) {
    runOnMainThread {
      self.circleInstance.userData = value
      self.replaceValue(value ?? NSNull(), forKey: "userData", notification: false)
    }
  }
}
