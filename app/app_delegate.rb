GOOGLE_MAP_API_KEY = "<YOUR GOOGLE KEY HERE>"

class GoogleMapsController < UIViewController

  def loadView
    camera = GMSCameraPosition.cameraWithLatitude(39.737567, longitude: -104.9847179, zoom: 15) # Denver
    @map_view = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
    @map_view.myLocationEnabled = true
    @map_view.settings.myLocationButton = true
    @map_view.delegate = self
    self.view = @map_view
    @markers = []

    # GEO
    Google::Geo.position("1705 Heron, Ln N, Oakdale, MN 55128") do |position|
      map(position)
      add_marker(position, position.latitude.to_s, position.longitude.to_s)
    end
  end

  def map(position)
    @map_view.camera = GMSCameraPosition.cameraWithLatitude(position.latitude, longitude: position.longitude, zoom: 15)
  end

  def add_marker(position, title="Title", snippet="Snippet")
    marker = GMSMarker.alloc.init
    marker.position = CLLocationCoordinate2DMake(position.latitude, position.longitude)
    marker.title = title
    marker.snippet = snippet
    marker.map = @map_view
    @markers << marker
    marker
  end
  
  ############################################################################
  # Map Delegate

  def mapView(mapView, didTapAtCoordinate:coordinate)
    add_marker(coordinate, coordinate.latitude.to_s, coordinate.longitude.to_s)
    if @markers.length > 1
      if @markers.length > 2
        Google::Direction.directions(@markers[0].position, @markers[-1].position, @markers[1..-2].collect { |m| m.position }) do |route|
          mapRoute(route)
        end
      else
        Google::Direction.directions(@markers[0].position, @markers[-1].position) do |route|
          mapRoute(route)
        end
      end
    end
  end

  def mapView(mapView, idleAtCameraPosition:cameraPosition)
    # No more movement...
  end

  def mapRoute(route)
    path = GMSPath.pathFromEncodedPath(route)
    polyline = GMSPolyline.polylineWithPath(path)
    polyline.map = @map_view
  end

end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    GMSServices.provideAPIKey(GOOGLE_MAP_API_KEY)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = GoogleMapsController.new
    @window.makeKeyAndVisible
    true
  end
end