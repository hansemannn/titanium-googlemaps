/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import UIKit
import TitaniumKit
import GoogleMaps

@objc(TiGooglemapsPolygonProxy)
public class TiGooglemapsPolygonProxy: TiProxy {
  private var polygonInternal: GMSPolygon?
  
  private var polygonInstance: GMSPolygon {
    if let polygon = polygonInternal {
      return polygon
    }
    
    let polygon = GMSPolygon()
    polygon.isTappable = true
    polygonInternal = polygon
    return polygon
  }
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func append(point: Any, to path: GMSMutablePath) {
    if let dict = point as? [String: Any] {
      let latitude = TiUtils.doubleValue(dict["latitude"])
      let longitude = TiUtils.doubleValue(dict["longitude"])
      path.addLatitude(latitude, longitude: longitude)
    } else if let array = point as? [Any], array.count >= 2 {
      let latitude = TiUtils.doubleValue(array[1])
      let longitude = TiUtils.doubleValue(array[0])
      path.addLatitude(latitude, longitude: longitude)
    }
  }
  
  @objc public func polygon() -> GMSPolygon {
    return polygonInstance
  }
  
  @objc public func setPoints(_ value: [Any]?) {
    runOnMainThread {
      guard let points = value, points.count >= 2 else {
        NSLog("[WARN] Ti.GoogleMaps: You need to specify at least 2 points to create a polygon.")
        return
      }
      
      let path = GMSMutablePath()
      points.forEach { self.append(point: $0, to: path) }
      self.polygonInstance.path = path
      self.replaceValue(points, forKey: "points", notification: false)
    }
  }
  
  @objc public func setTappable(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.isTappable = TiUtils.boolValue(value)
      self.replaceValue(value, forKey: "tappable", notification: false)
    }
  }
  
  @objc public func setFillColor(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.fillColor = TiUtils.colorValue(value)?.color
      self.replaceValue(value, forKey: "fillColor", notification: false)
    }
  }
  
  @objc public func setStrokeColor(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.strokeColor = TiUtils.colorValue(value)?.color
      self.replaceValue(value, forKey: "strokeColor", notification: false)
    }
  }
  
  @objc public func setStrokeWidth(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.strokeWidth = CGFloat(TiUtils.floatValue(value, def: 1))
      self.replaceValue(value, forKey: "strokeWidth", notification: false)
    }
  }
  
  @objc public func setGeodesic(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.geodesic = TiUtils.boolValue(value, def: false)
      self.replaceValue(value, forKey: "geodesic", notification: false)
    }
  }
  
  @objc public func setTitle(_ value: Any?) {
    runOnMainThread {
      let title = TiUtils.stringValue(value)
      self.polygonInstance.title = title
      self.replaceValue(title ?? NSNull(), forKey: "title", notification: false)
    }
  }
  
  @objc public func setZIndex(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.zIndex = Int32(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "zIndex", notification: false)
    }
  }
  
  @objc public func setHoles(_ value: [Any]?) {
    runOnMainThread {
      guard let holesArray = value else { return }
      var holes: [GMSMutablePath] = []
      
      for case let holePoints as [Any] in holesArray {
        let path = GMSMutablePath()
        holePoints.forEach { self.append(point: $0, to: path) }
        holes.append(path)
      }
      
      self.polygonInstance.holes = holes
      self.replaceValue(value, forKey: "holes", notification: false)
    }
  }
  
  @objc public func setUserData(_ value: Any?) {
    runOnMainThread {
      self.polygonInstance.userData = value
      self.replaceValue(value ?? NSNull(), forKey: "userData", notification: false)
    }
  }
}
