Pod::Spec.new do |s|
  s.name         = 'StencilLayout'
  s.summary      = 'iOS一种基于模版的布局模式，旨在支持广告位灵活配置，高效运营，UI动态生成，提高开发效率。'
  s.version      = '1.0.6'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'pcjbird' => 'pcjbird@hotmail.com' }
  s.social_media_url = 'http://www.lessney.com'
  s.homepage     = 'https://github.com/pcjbird/StencilLayout'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/pcjbird/StencilLayout.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'StencilLayout/*.{h,m,pch}','StencilLayout/public_headers/*.{h}','StencilLayout/Categories/*.{h,m}','StencilLayout/Util/*.{h,m}'
  s.public_header_files = 'StencilLayout/public_headers/*.{h}'
  s.prefix_header_file = 'StencilLayout/StencilLayoutPrefix.pch'
  s.frameworks = 'Foundation','UIKit','WebKit','CoreFoundation','Accelerate','AssetsLibrary','ImageIO','MobileCoreServices','QuartzCore'

  s.resource_bundles = {
   'StencilLayout' => ['StencilLayout/resource/*.*'],
  }
  
  s.dependency 'YYImage/WebP'
  s.dependency 'YYWebImage'

  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  
end
