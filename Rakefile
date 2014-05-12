# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  require 'bubble-wrap/location'
  require 'bubble-wrap/http'
  require 'bubble-wrap/core'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Route'
  app.identifier = 'com.ironsafe.Route'
  app.interface_orientations = [:portrait]
  app.prerendered_icon = false
  #app.frameworks += ['QuartzCore', 'CoreData']
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  app.vendor_project('vendor/GoogleMaps.framework',
    :static,
    :products    => %w{GoogleMaps},
    :headers_dir => 'Headers')
  app.resources_dirs << 'vendor/GoogleMaps.framework/Resources'
  app.frameworks += %w{AVFoundation CoreData CoreLocation CoreText GLKit ImageIO OpenGLES QuartzCore SystemConfiguration}
  app.libs       += %w{/usr/lib/libicucore.dylib /usr/lib/libc++.dylib /usr/lib/libz.dylib}

  app.development do
    # This entitlement is required during development but must not be used for release.
    app.entitlements['get-task-allow'] = true
  end

end
