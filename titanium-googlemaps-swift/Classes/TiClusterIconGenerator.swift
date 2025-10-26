//
//  TiClusterIconGenerator.swift
//  TiGooglemaps
//
//  Created by Hans Knöchel on 26.10.25.
//

import UIKit
import GoogleMapsUtils

@objc(TiClusterIconGenerator)
class TiClusterIconGenerator: GMUDefaultClusterIconGenerator {
  override init(buckets: [NSNumber], backgroundImages images: [UIImage]) {
    super.init(buckets: buckets, backgroundImages: images)
  }
  
  override init(buckets: [NSNumber]) {
    super.init(buckets: buckets)
  }
  
  override init() {
    super.init()
  }
}
