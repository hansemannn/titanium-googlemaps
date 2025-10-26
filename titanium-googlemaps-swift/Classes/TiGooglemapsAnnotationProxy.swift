/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import UIKit
import TitaniumKit
import GoogleMaps
import QuartzCore

@objc(TiGooglemapsAnnotationProxy)
public class TiGooglemapsAnnotationProxy: TiProxy {
  private var markerInternal: GMSMarker?
  private var customViewProxy: TiViewProxy?
  private var infoWindowProxy: TiViewProxy?
  
  // MARK: - Lifecycle
  
  @objc(_initWithPageContext:andMarker:)
  public func _init(withPageContext context: TiEvaluator?, andMarker marker: GMSMarker) -> Self? {
    guard let proxy = super._init(withPageContext: context) else {
      return nil
    }
    
    markerInternal = marker
    replaceValue(marker.position.latitude, forKey: "latitude", notification: false)
    replaceValue(marker.position.longitude, forKey: "longitude", notification: false)
    replaceValue(marker.title ?? NSNull(), forKey: "title", notification: false)
    replaceValue(marker.snippet ?? NSNull(), forKey: "subtitle", notification: false)
    
    ensureUserDataHasUUID()
    
    return proxy
  }
  
  // MARK: - Helpers
  
  private func runOnMainThread(wait: Bool = false, _ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, wait)
    }
  }
  
  private func ensureUserDataHasUUID() {
    guard let marker = markerInternal else { return }
    
    if var data = marker.userData as? [String: Any] {
      if data["uuid"] == nil {
        data["uuid"] = UUID().uuidString
        marker.userData = data
      }
    } else {
      marker.userData = ["uuid": UUID().uuidString]
    }
  }
  
  private func currentCoordinate() -> CLLocationCoordinate2D {
    let latitude = TiUtils.doubleValue(value(forKey: "latitude"))
    let longitude = TiUtils.doubleValue(value(forKey: "longitude"))
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  private func updateMarkerPositionIfPossible() {
    guard let marker = markerInternal else { return }
    marker.position = currentCoordinate()
  }
  
  private func number(from value: Any?) -> NSNumber? {
    if let number = value as? NSNumber {
      return number
    }
    
    if let string = value as? String, let doubleValue = Double(string) {
      return NSNumber(value: doubleValue)
    }
    
    return nil
  }
  
  // MARK: - Public API
  
  @objc public var marker: GMSMarker {
    if let marker = markerInternal {
      return marker
    }
    
    let marker = GMSMarker()
    marker.position = currentCoordinate()
    marker.isTappable = true
    marker.userData = ["uuid": UUID().uuidString]
    markerInternal = marker
    return marker
  }
  
  @objc public func infoWindow() -> TiViewProxy? {
    return infoWindowProxy
  }
  
  @objc public func setInfoWindow(_ value: Any?) {
    infoWindowProxy = value as? TiViewProxy
    replaceValue(value, forKey: "infoWindow", notification: false)
  }
  
  @objc public func setLatitude(_ value: Any?) {
    replaceValue(value, forKey: "latitude", notification: false)
    updateMarkerPositionIfPossible()
  }
  
  @objc public func setLongitude(_ value: Any?) {
    replaceValue(value, forKey: "longitude", notification: false)
    updateMarkerPositionIfPossible()
  }
  
  @objc public func setTitle(_ value: Any?) {
    runOnMainThread {
      let title = TiUtils.stringValue(value)
      self.marker.title = title
      self.replaceValue(title ?? NSNull(), forKey: "title", notification: false)
    }
  }
  
  @objc public func setSubtitle(_ value: Any?) {
    runOnMainThread {
      let subtitle = TiUtils.stringValue(value)
      self.marker.snippet = subtitle
      self.replaceValue(subtitle ?? NSNull(), forKey: "subtitle", notification: false)
    }
  }
  
  @objc public func setZIndex(_ value: Any?) {
    runOnMainThread {
      self.marker.zIndex = Int32(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "zIndex", notification: false)
    }
  }
  
  @objc public func setCenterOffset(_ value: Any?) {
    runOnMainThread {
      self.marker.infoWindowAnchor = TiUtils.pointValue(value)
      self.replaceValue(value, forKey: "centerOffset", notification: false)
    }
  }
  
  @objc public func setGroundOffset(_ value: Any?) {
    runOnMainThread {
      self.marker.groundAnchor = TiUtils.pointValue(value)
      self.replaceValue(value, forKey: "groundOffset", notification: false)
    }
  }
  
  @objc public func setImage(_ value: Any?) {
    runOnMainThread {
      self.marker.icon = TiUtils.image(value, proxy: self)
      self.replaceValue(value, forKey: "image", notification: false)
    }
  }
  
  @objc public func setCustomIcon(_ value: Any?) {
    guard let dictionary = value as? [String: Any] else { return }
    
    runOnMainThread {
      let textColor = TiUtils.colorValue(dictionary["textColor"])?.color ?? .black
      let tintColor = TiUtils.colorValue(dictionary["tintColor"])?.color
      let title = TiUtils.stringValue(dictionary["title"]) ?? ""
      let image = TiUtils.image(dictionary["image"], proxy: self)
      let font = TiUtils.fontValue(dictionary["font"])?.font() ?? UIFont.systemFont(ofSize: 12, weight: .regular)
      
      let imageView = UIImageView(image: image)
      imageView.frame = CGRect(origin: .zero, size: image?.size ?? .zero)
      if let tintColor = tintColor {
        imageView.tintColor = tintColor
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
      }
      
      let labelFrame = CGRect(origin: .zero, size: CGSize(width: imageView.bounds.width, height: imageView.bounds.width))
      let titleLabel = UILabel(frame: labelFrame)
      titleLabel.font = font
      titleLabel.text = title
      titleLabel.textAlignment = .center
      titleLabel.textColor = textColor
      
      let container = UIView(frame: imageView.bounds)
      container.addSubview(imageView)
      container.addSubview(titleLabel)
      
      self.marker.iconView = container
      self.marker.tracksViewChanges = false
      self.replaceValue(dictionary, forKey: "customIcon", notification: false)
    }
  }
  
  @objc public func setPinColor(_ value: Any?) {
    runOnMainThread {
      if let color = TiUtils.colorValue(value)?.color {
        self.marker.icon = GMSMarker.markerImage(with: color)
      }
      self.replaceValue(value, forKey: "pinColor", notification: false)
    }
  }
  
  @objc public func setTouchEnabled(_ value: Any?) {
    runOnMainThread {
      self.marker.isTappable = TiUtils.boolValue(value, def: true)
      self.replaceValue(value, forKey: "touchEnabled", notification: false)
    }
  }
  
  @objc public func setFlat(_ value: Any?) {
    runOnMainThread {
      self.marker.isFlat = TiUtils.boolValue(value, def: false)
      self.replaceValue(value, forKey: "flat", notification: false)
    }
  }
  
  @objc public func setDraggable(_ value: Any?) {
    runOnMainThread {
      self.marker.isDraggable = TiUtils.boolValue(value, def: false)
      self.replaceValue(value, forKey: "draggable", notification: false)
    }
  }
  
  @objc public func setOpacity(_ value: Any?) {
    runOnMainThread {
      self.marker.opacity = Float(TiUtils.floatValue(value, def: 1))
      self.replaceValue(value, forKey: "opacity", notification: false)
    }
  }
  
  @objc public func setAnimationStyle(_ value: Any?) {
    runOnMainThread {
      let defaultAnimation = GMSMarkerAnimation.none
      let rawValue = TiUtils.intValue(value, def: Int32(defaultAnimation.rawValue))
      self.marker.appearAnimation = GMSMarkerAnimation(rawValue: UInt(rawValue)) ?? defaultAnimation
      self.replaceValue(value, forKey: "animationStyle", notification: false)
    }
  }
  
  @objc public func setRotation(_ value: Any?) {
    runOnMainThread {
      self.marker.rotation = TiUtils.doubleValue(value, def: 0)
      self.replaceValue(value, forKey: "rotation", notification: false)
    }
  }
  
  @objc public func setUserData(_ value: Any?) {
    runOnMainThread {
      var result = value as? [String: Any] ?? [:]
      if let uuid = (self.marker.userData as? [String: Any])?["uuid"] {
        result["uuid"] = uuid
      } else if result["uuid"] == nil {
        result["uuid"] = UUID().uuidString
      }
      self.marker.userData = result
      self.replaceValue(result, forKey: "userData", notification: false)
    }
  }
  
  @objc public func updateLocation(_ args: [String: Any]) {
    runOnMainThread {
      let latitude = self.number(from: args["latitude"])
      let longitude = self.number(from: args["longitude"])
      let animated = TiUtils.boolValue(args["animated"], def: false)
      let duration = TiUtils.floatValue(args["duration"], def: 2000) / 1000
      let rotation = self.number(from: args["rotation"])
      let opacity = self.number(from: args["opacity"])
      
      let updateBlock = {
        if let lat = latitude, let lon = longitude {
          let coordinate = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: lon.doubleValue)
          self.marker.position = coordinate
          self.replaceValue(lat, forKey: "latitude", notification: false)
          self.replaceValue(lon, forKey: "longitude", notification: false)
        }
        
        if let rotation = rotation {
          self.marker.rotation = rotation.doubleValue
          self.replaceValue(rotation, forKey: "rotation", notification: false)
        }
        
        if let opacity = opacity {
          self.marker.opacity = opacity.floatValue
          self.replaceValue(opacity, forKey: "opacity", notification: false)
        }
      }
      
      if animated {
        CATransaction.begin()
        CATransaction.setAnimationDuration(CFTimeInterval(duration))
        updateBlock()
        CATransaction.commit()
      } else {
        updateBlock()
      }
    }
  }
  
  @objc public func setCustomView(_ value: Any?) {
    runOnMainThread {
      let previous = self.customViewProxy
      var newProxy: TiViewProxy?
      
      if let proxy = value as? TiViewProxy {
        newProxy = proxy
        self.remember(proxy)
        self.marker.iconView = proxy.view
      } else {
        self.marker.iconView = nil
      }
      
      if let previous = previous, previous !== newProxy {
        self.forget(previous)
      }
      
      self.customViewProxy = newProxy
      self.replaceValue(value ?? NSNull(), forKey: "customView", notification: false)
    }
  }
  
  // MARK: - Overrides
  
  public override func keySequence() -> [Any]! {
    return ["latitude", "longitude"]
  }
}
