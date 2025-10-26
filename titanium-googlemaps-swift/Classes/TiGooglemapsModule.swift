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
import CoreLocation

@objc(TiGooglemapsModule)
class TiGooglemapsModule: TiModule {
  private var apiKey: String?
  
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
    
    self.apiKey = apiKey
    GMSServices.provideAPIKey(apiKey)
  }
  
  @objc(openSourceLicenseInfo:)
  func openSourceLicenseInfo(unused: Any?) -> String? {
    var openSourceLicenseInfo: String?
    
    TiThreadPerformOnMainThread({
      openSourceLicenseInfo = GMSServices.openSourceLicenseInfo()
    }, true)
    
    return openSourceLicenseInfo
  }
  
  @objc(version:)
  func version(unused: Any?) -> String? {
    var currentVersion: String?
    
    TiThreadPerformOnMainThread({
      currentVersion = GMSServices.sdkVersion()
    }, true)
    
    return currentVersion
  }
  
  @objc(reverseGeocoder:)
  func reverseGeocoder(args: [Any]) {
    if !Thread.isMainThread {
      TiThreadPerformOnMainThread({
        self.reverseGeocoder(args: args)
      }, false)
      return
    }
    
    guard args.count >= 3,
          let latitude = args[0] as? NSNumber,
          let longitude = args[1] as? NSNumber,
          let callback = args[2] as? KrollCallback else {
      return
    }
    
    let coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    
    GMSGeocoder().reverseGeocodeCoordinate(coordinate) { [weak self] response, _ in
      guard let self = self else { return }
      
      var properties: [String: Any] = [
        "firstPlace": self.dictionaryFromAddress(response?.firstResult()) ?? NSNull(),
        "places": self.arrayFromAddresses(response?.results())
      ]
      
      if let results = response?.results, !(results()?.isEmpty ?? false) {
        properties["code"] = 0
        properties["success"] = true
      } else {
        properties["error"] = "No places found"
        properties["code"] = 1
        properties["success"] = false
      }
      
      callback.call([properties], thisObject: self)
    }
  }
  
  @objc(getDirections:)
  func getDirections(args: [Any]) {
    guard let params = args.first as? [String: Any],
          let successCallback = params["success"] as? KrollCallback,
          let errorCallback = params["error"] as? KrollCallback,
          let origin = params["origin"] as? String,
          let destination = params["destination"] as? String else {
      return
    }
    
    let waypoints: [String]? = {
      if let strings = params["waypoints"] as? [String] {
        return strings
      }
      
      if let anyValues = params["waypoints"] as? [Any] {
        return anyValues.compactMap { $0 as? String }
      }
      
      return nil
    }()
    
    guard let apiKey = apiKey, !apiKey.isEmpty else {
      let errorObject: [String: Any] = ["code": 1, "message": "API key not set"]
      TiThreadPerformOnMainThread({
        errorCallback.call([errorObject], thisObject: self)
      }, false)
      return
    }
    
    let httpClient = TiGMSHTTPClient(apiKey: apiKey)
    
    var options: [String: Any] = [
      "origin": origin,
      "destination": destination
    ]
    
    if let formattedWaypoints = TiGMSHTTPClient.formattedWaypoints(from: waypoints) {
      options["waypoints"] = formattedWaypoints
    }
    
    httpClient.load(withRequestPath: "directions/json", andOptions: options) { [weak self] json, error in
      guard let self = self else { return }
      
      if let error = error {
        let errorObject: [String: Any] = ["code": 1, "message": error.localizedDescription]
        TiThreadPerformOnMainThread({
          errorCallback.call([errorObject], thisObject: self)
        }, false)
        return
      }
      
      guard let json = json else {
        let errorObject: [String: Any] = ["code": 1, "message": "Empty response"]
        TiThreadPerformOnMainThread({
          errorCallback.call([errorObject], thisObject: self)
        }, false)
        return
      }
      
      TiThreadPerformOnMainThread({
        successCallback.call([json], thisObject: self)
      }, false)
    }
  }
  
  @objc(geometryContainsLocation:)
  func geometryContainsLocation(arguments: Any?) -> NSNumber? {
    guard let params = arguments as? [String: Any],
          let location = params["location"] as? [String: Any],
          let path = params["path"] as? [[NSNumber]],
          let latitudeValue = location["latitude"],
          let longitudeValue = location["longitude"] else {
      return nil
    }
    
    let latitude = doubleValue(from: latitudeValue)
    let longitude = doubleValue(from: longitudeValue)
    
    let mutablePath = GMSMutablePath()
    
    path.forEach { coordinate in
      guard coordinate.count == 2 else { return }
      let coordinateLatitude = coordinate[0].doubleValue
      let coordinateLongitude = coordinate[1].doubleValue
      mutablePath.add(CLLocationCoordinate2D(latitude: coordinateLatitude, longitude: coordinateLongitude))
    }
    
    let containsLocation = GMSGeometryContainsLocation(
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
      mutablePath,
      true
    )
    
    return NSNumber(value: containsLocation)
  }
  
  @objc(geometryDistanceBetweenPoints:)
  func geometryDistanceBetweenPoints(locations: [Any]) -> NSNumber? {
    guard locations.count == 2,
          let location1 = locations[0] as? [String: Any],
          let location2 = locations[1] as? [String: Any] else {
      return nil
    }
    
    let latitude1 = doubleValue(from: location1["latitude"])
    let longitude1 = doubleValue(from: location1["longitude"])
    let latitude2 = doubleValue(from: location2["latitude"])
    let longitude2 = doubleValue(from: location2["longitude"])
    
    let distance = GMSGeometryDistance(
      CLLocationCoordinate2D(latitude: latitude1, longitude: longitude1),
      CLLocationCoordinate2D(latitude: latitude2, longitude: longitude2)
    )
    
    return NSNumber(value: distance)
  }
  
  @objc(createClusterItem:)
  func createClusterItem(args: [Any]) -> TiGooglemapsClusterItemProxy? {
    guard let params = args.first as? [String: Any] else { return nil }
    
    guard let latitudeValue = params["latitude"],
          let longitudeValue = params["longitude"] else {
      return nil
    }
    
    let latitude = doubleValue(from: latitudeValue)
    let longitude = doubleValue(from: longitudeValue)
    
    let title = params["title"] as? String
    let subtitle = params["subtitle"] as? String
    let icon = params["icon"]
    let userData = params["userData"] as? [AnyHashable: Any]
    
    return TiGooglemapsClusterItemProxy()._init(
      withPageContext: pageContext,
      andPosition: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
      title: title,
      subtitle: subtitle,
      icon: icon,
      userData: userData
    )
  }
  
  @objc(decodePolylinePoints:)
  func decodePolylinePoints(args: [Any]) -> [[String: Double]]? {
    guard let polylinePoints = args.first as? String,
          let path = GMSPath(fromEncodedPath: polylinePoints) else {
      return nil
    }
    
    var coordinates: [[String: Double]] = []
    
    for index in 0 ..< Int(path.count()) {
      let location = path.coordinate(at: UInt(index))
      coordinates.append([
        "latitude": location.latitude,
        "longitude": location.longitude
      ])
    }
    
    return coordinates
  }
  
  private func dictionaryFromAddress(_ address: GMSAddress?) -> [String: Any]? {
    guard let address = address else { return nil }
    
    var result: [String: Any] = [:]
    
    if address.coordinate.latitude != 0 && address.coordinate.longitude != 0 {
      result["latitude"] = address.coordinate.latitude
      result["longitude"] = address.coordinate.longitude
    }
    
    if let thoroughfare = address.thoroughfare {
      result["thoroughfare"] = thoroughfare
    }
    
    if let locality = address.locality {
      result["locality"] = locality
    }
    
    if let subLocality = address.subLocality {
      result["subLocality"] = subLocality
    }
    
    if let administrativeArea = address.administrativeArea {
      result["administrativeArea"] = administrativeArea
    }
    
    if let postalCode = address.postalCode {
      result["postalCode"] = postalCode
    }
    
    if let country = address.country {
      result["country"] = country
    }
    
    if let lines = address.lines {
      result["lines"] = lines
    }
    
    return result
  }
  
  private func arrayFromAddresses(_ addresses: [GMSAddress]?) -> [[String: Any]] {
    guard let addresses = addresses else { return [] }
    
    return addresses.compactMap { dictionaryFromAddress($0) }
  }
  
  private func doubleValue(from value: Any?) -> CLLocationDegrees {
    if let number = value as? NSNumber {
      return number.doubleValue
    }
    
    if let string = value as? String, let doubleValue = Double(string) {
      return doubleValue
    }
    
    return 0
  }
  
  @objc(MAP_TYPE_HYBRID)
  func MAP_TYPE_HYBRID() -> NSNumber {
    return NSNumber(value: GMSMapViewType.hybrid.rawValue)
  }
  
  @objc(MAP_TYPE_NONE)
  func MAP_TYPE_NONE() -> NSNumber {
    return NSNumber(value: GMSMapViewType.none.rawValue)
  }
  
  @objc(MAP_TYPE_NORMAL)
  func MAP_TYPE_NORMAL() -> NSNumber {
    return NSNumber(value: GMSMapViewType.normal.rawValue)
  }
  
  @objc(MAP_TYPE_SATELLITE)
  func MAP_TYPE_SATELLITE() -> NSNumber {
    return NSNumber(value: GMSMapViewType.satellite.rawValue)
  }
  
  @objc(MAP_TYPE_TERRAIN)
  func MAP_TYPE_TERRAIN() -> NSNumber {
    return NSNumber(value: GMSMapViewType.terrain.rawValue)
  }
  
  @objc(APPEAR_ANIMATION_NONE)
  func APPEAR_ANIMATION_NONE() -> NSNumber {
    return NSNumber(value: GMSMarkerAnimation.none.rawValue)
  }
  
  @objc(APPEAR_ANIMATION_POP)
  func APPEAR_ANIMATION_POP() -> NSNumber {
    return NSNumber(value: GMSMarkerAnimation.pop.rawValue)
  }
  
  @objc(APPEAR_ANIMATION_FADE)
  func APPEAR_ANIMATION_FADE() -> NSNumber {
    return NSNumber(value: GMSMarkerAnimation.fadeIn.rawValue)
  }
  
  @objc(PADDING_ADJUSTMENT_BEHAVIOR_ALWAYS)
  func PADDING_ADJUSTMENT_BEHAVIOR_ALWAYS() -> NSNumber {
    return NSNumber(value: GMSMapViewPaddingAdjustmentBehavior.always.rawValue)
  }
  
  @objc(PADDING_ADJUSTMENT_BEHAVIOR_AUTOMATIC)
  func PADDING_ADJUSTMENT_BEHAVIOR_AUTOMATIC() -> NSNumber {
    return NSNumber(value: GMSMapViewPaddingAdjustmentBehavior.automatic.rawValue)
  }
  
  @objc(PADDING_ADJUSTMENT_BEHAVIOR_NEVER)
  func PADDING_ADJUSTMENT_BEHAVIOR_NEVER() -> NSNumber {
    return NSNumber(value: GMSMapViewPaddingAdjustmentBehavior.never.rawValue)
  }
}
