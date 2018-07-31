Pod::Spec.new do |s|
s.name             = 'SwiftyProxy'
s.version          = '0.1.0'
s.summary          = 'A Proxy UI to inspect http/https trafic'
s.homepage         = 'https://github.com/samirGuerdah/SwiftyProxy'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Samir Guerdah' => 'sguerdah@gmail.com' }
s.source           = { :git => 'https://github.com/samirGuerdah/SwiftyProxy.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/GuerdahSamir'
s.swift_version = '4.0'

s.frameworks = 'Foundation'
s.ios.frameworks = 'UIKit'
s.requires_arc = true
s.ios.deployment_target = '10.0'
s.source_files = 'SwiftyProxy/Classes/**/*'
s.resources = ['SwiftyProxy/Assets/*.png']
end
