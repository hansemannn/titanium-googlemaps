//
//  TiClusterRenderer.swift
//  TiGooglemaps
//
//  Created by Hans Knöchel on 26.10.25.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils

@objc(TiClusterRenderer)
class TiClusterRenderer: GMUDefaultClusterRenderer {
  override init(mapView: GMSMapView, clusterIconGenerator iconGenerator: GMUClusterIconGenerator) {
    super.init(mapView: mapView, clusterIconGenerator: iconGenerator)
  }
}
