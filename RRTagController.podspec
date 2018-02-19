Pod::Spec.new do |s|
  s.name             = 'RRTagController'
  s.version          = '0.1.0'
  s.summary          = 'RRTagController allows user to select tag and create new one.'

  s.homepage         = 'https://github.com/alexruperez/RRTagController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Rémi Robert' => 'remirobert33530@gmail.com', 'Alex Rupérez' => 'contact@alexruperez.com' }
  s.source           = { :git => 'https://github.com/alexruperez/RRTagController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexruperez'
  s.module_name      = 'RRTagController'

  s.ios.deployment_target = '9.0'
  s.source_files          = 'source/*.{h,swift}'
  s.frameworks            = 'Foundation', 'UIKit'
end