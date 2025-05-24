# Claude Code Configuration

## Project Overview

This is the Titanium GoogleMaps module - a native iOS module that provides Google Maps SDK integration for Appcelerator Titanium Mobile applications. The module supports map views, annotations, overlays, clustering, directions, and various other Google Maps features.

## Project Structure

- `Classes/` - Native Objective-C implementation files for the module
- `platform/` - Google Maps iOS SDK frameworks (GoogleMaps, GoogleMapsUtils, GooglePlaces)
- `example/` - Example applications demonstrating module features
- `Resources/` - Resource bundles and localization files
- Root configuration files for Xcode project and module manifest

## Key Files

- `manifest` - Module metadata and version information
- `timodule.xml` - Titanium module configuration
- `module.xcconfig` - Xcode build configuration
- `ti.googlemaps.xcodeproj/` - Xcode project files

## Dependencies

- Titanium SDK 12.0.0+
- iOS 15+ minimum deployment target
- Google Maps iOS SDK (included in platform/)
- Google Places iOS SDK (included in platform/)
- Google Maps Utils SDK (included in platform/)

## Module Information

- Version: 10.0.0
- Platform: iPhone/iOS only
- Architecture: arm64, x86_64
- Author: Hans Knoechel
- License: Apache License

## Development Notes

- Supports clustering, heatmaps, directions, and geocoding
- Requires Google Maps API key for functionality
- Cross-platform compatible with ti.map module on Android
