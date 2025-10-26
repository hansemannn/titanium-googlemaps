/**
 * Axway Titanium
 */

import UIKit
import TitaniumKit
import GoogleMaps
import GoogleMapsUtils

@objc(TiGooglemapsPolylineProxy)
public class TiGooglemapsPolylineProxy: TiProxy {
  private var polylineInternal: GMSPolyline?
  
  private var polylineInstance: GMSPolyline {
    if let polyline = polylineInternal {
      return polyline
    }
    
    let polyline = GMSPolyline()
    polyline.isTappable = true
    polylineInternal = polyline
    return polyline
  }
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func path(from points: Any?) -> GMSMutablePath? {
    guard let points = points else { return nil }
    
    if let encoded = points as? String, let path = GMSMutablePath(fromEncodedPath: encoded) {
      return path
    }
    
    guard let collection = points as? [Any], collection.count >= 2 else {
      NSLog("[WARN] Ti.GoogleMaps: You need to specify at least 2 points to create a polyline.")
      return nil
    }
    
    let path = GMSMutablePath()
    collection.forEach { point in
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
    
    return path
  }
  
  @objc public func polyline() -> GMSPolyline {
    return polylineInstance
  }
  
  @objc public func setPoints(_ value: Any?) {
    runOnMainThread {
      guard let path = self.path(from: value) else { return }
      self.polylineInstance.path = path
      self.replaceValue(value ?? NSNull(), forKey: "points", notification: false)
    }
  }
  
  @objc public func setDotsImage(_ value: Any?) {
    runOnMainThread {
      guard let dotsImage = value else {
        self.polylineInstance.spans = []
        self.replaceValue(NSNull(), forKey: "dotsImage", notification: false)
        return
      }
      
      guard let image = TiUtils.image(dotsImage, proxy: self) else { return }
      let strokeStyle = GMSStrokeStyle()
      strokeStyle.stampStyle = GMSTextureStyle(image: image)
      self.polylineInstance.spans = [GMSStyleSpan(style: strokeStyle)]
      self.replaceValue(dotsImage, forKey: "dotsImage", notification: false)
    }
  }
  
  @objc public func setTappable(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.isTappable = TiUtils.boolValue(value)
      self.replaceValue(value, forKey: "tappable", notification: false)
    }
  }
  
  @objc public func setStrokeColor(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.strokeColor = TiUtils.colorValue(value).color
      self.replaceValue(value, forKey: "strokeColor", notification: false)
    }
  }
  
  @objc public func setStrokeWidth(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.strokeWidth = CGFloat(TiUtils.floatValue(value, def: 1))
      self.replaceValue(value, forKey: "strokeWidth", notification: false)
    }
  }
  
  @objc public func setGeodesic(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.geodesic = TiUtils.boolValue(value, def: false)
      self.replaceValue(value, forKey: "geodesic", notification: false)
    }
  }
  
  @objc public func setTitle(_ value: Any?) {
    runOnMainThread {
      let title = TiUtils.stringValue(value)
      self.polylineInstance.title = title
      self.replaceValue(title ?? NSNull(), forKey: "title", notification: false)
    }
  }
  
  @objc public func setZIndex(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.zIndex = Int32(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "zIndex", notification: false)
    }
  }
  
  @objc public func setUserData(_ value: Any?) {
    runOnMainThread {
      self.polylineInstance.userData = value
      self.replaceValue(value ?? NSNull(), forKey: "userData", notification: false)
    }
  }
  
  @objc public func setStrokeGradient(_ value: [String: Any]?) {
    runOnMainThread {
      guard let gradient = value,
            let fromColor = TiUtils.colorValue(gradient["from"])?.color,
            let toColor = TiUtils.colorValue(gradient["to"])?.color else {
        return
      }
      
      let strokeStyle = GMSStrokeStyle.gradient(from: fromColor, to: toColor)
      self.polylineInstance.spans = [GMSStyleSpan(style: strokeStyle)]
      self.replaceValue(value ?? NSNull(), forKey: "spans", notification: false)
    }
  }
}
