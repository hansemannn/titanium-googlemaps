/**
 * Axway Titanium
 */

import UIKit
import TitaniumKit
import GoogleMaps

@objc(TiGooglemapsTileProxy)
public class TiGooglemapsTileProxy: TiProxy, GMSTileReceiver {
  private var tileLayer: GMSURLTileLayer?
  
  private func number(from value: Any?) -> NSNumber? {
    if let number = value as? NSNumber {
      return number
    }
    if let string = value as? String, let doubleValue = Double(string) {
      return NSNumber(value: doubleValue)
    }
    return nil
  }
  
  private func runOnMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      TiThreadPerformOnMainThread(block, false)
    }
  }
  
  private func templateURL() -> String? {
    return value(forKey: "url") as? String
  }
  
  @objc public func tile() -> GMSURLTileLayer {
    if let tileLayer = tileLayer {
      return tileLayer
    }
    
    let constructor: GMSTileURLConstructor = { [weak self] x, y, zoom in
      guard let template = self?.templateURL() else { return nil }
      var resolved = template.replacingOccurrences(of: "{x}", with: "\(x)")
      resolved = resolved.replacingOccurrences(of: "{y}", with: "\(y)")
      resolved = resolved.replacingOccurrences(of: "{z}", with: "\(zoom)")
      return URL(string: resolved)
    }
    
    let layer = GMSURLTileLayer(urlConstructor: constructor)
    tileLayer = layer
    return layer
  }
  
  // MARK: - Public API
  
  @objc public func setZIndex(_ value: Any?) {
    runOnMainThread {
      self.tile().zIndex = Int32(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "zIndex", notification: false)
    }
  }
  
  @objc public func setOpacity(_ value: Any?) {
    runOnMainThread {
      self.tile().opacity = Float(TiUtils.floatValue(value))
      self.replaceValue(value, forKey: "opacity", notification: false)
    }
  }
  
  @objc public func setFadeIn(_ value: Any?) {
    runOnMainThread {
      self.tile().fadeIn = TiUtils.boolValue(value)
      self.replaceValue(value, forKey: "fadeIn", notification: false)
    }
  }
  
  @objc public func setSize(_ value: Any?) {
    runOnMainThread {
      self.tile().tileSize = Int(TiUtils.intValue(value))
      self.replaceValue(value, forKey: "size", notification: false)
    }
  }
  
  @objc public func setUserAgent(_ value: Any?) {
    runOnMainThread {
      self.tile().userAgent = TiUtils.stringValue(value)
      self.replaceValue(value, forKey: "userAgent", notification: false)
    }
  }
  
  @objc public func clearTileCache(_ unused: Any?) {
    runOnMainThread {
      self.tile().clearTileCache()
    }
  }
  
  @objc public func requestTile(_ args: [String: Any]) {
    runOnMainThread {
      guard let xNumber = self.number(from: args["x"]),
            let yNumber = self.number(from: args["y"]),
            let zoomNumber = self.number(from: args["zoom"]) else {
        return
      }
      
      self.tile().requestTileFor(x: xNumber.uintValue, y: yNumber.uintValue,
                                  zoom: zoomNumber.uintValue,
                                  receiver: self)
    }
  }
  
  // MARK: - GMSTileReceiver
  
  public func receiveTileWith(x: UInt, y: UInt, zoom: UInt, image: UIImage?) {
    guard _hasListeners("receivetile"), let image = image else { return }
    
    let event: [String: Any] = [
      "x": NSNumber(value: x),
      "y": NSNumber(value: y),
      "zoom": NSNumber(value: zoom),
      "image": TiBlob(image: image) ?? NSNull()
    ]
    
    fireEvent("receivetile", with: ["tile": event])
  }
}
