Pod::Spec.new do |s|
  s.name         = 'StencilLayout'
  s.summary      = 'iOS一种基于模版的布局模式，旨在支持广告位灵活配置，高效运营，UI动态生成，提高开发效率。'
  s.version      = '1.0.2'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'pcjbird' => 'pcjbird@hotmail.com' }
  s.social_media_url = 'http://www.lessney.com'
  s.homepage     = 'https://github.com/pcjbird/StencilLayout'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/pcjbird/StencilLayout.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'StencilLayout/source/*.{h,m}','StencilLayout/source/Categories/*.{h,m}','StencilLayout/source/Util/*.{h,m}'
  s.public_header_files = 'StencilLayout/public/*.{h}'
  s.frameworks = 'Foundation','UIKit','WebKit'

  s.resources = "StencilLayoutResource/StencilLayout.bundle"
  
  s.dependency 'YYImage/WebP'
  s.dependency 'YYWebImage'
  
end