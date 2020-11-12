# Downloading Google Maps files

Since Google Maps is now > 100MB large, wwe do not store them in Git anymore (unttil git-lfs is properly set up).
Until then, please download the frameworks manually orr via Carthage and place them here. Required files are:

- GoogleMaps.framework
- GoogleMapsBase.framework
- GoogleMapsCore.framework
- GooglePlaces.framework

## Download via Carthage (preferred)

1. Go to the project root
2. Run `carthage update --plaform iOS`
3. Go to `Carthage/Build/` and copy the above framework to this folder
4. Build the module with `ti build -p ios --build-only` 

## Download manually

Download from here: https://developers.google.com/maps/documentation/ios-sdk/start#install-manually
