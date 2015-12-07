Pod::Spec.new do |s|
  s.platform                = :ios, '7.0'
  s.name                    = 'CMUtils'
  s.version                 = '0.1.7'
  s.summary                 = 'iOS development class catgories and venders, boost development fastly.'
  s.homepage                = 'https://github.com/imjerrybao/CMUtils'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Jerry' => 'imjerrybao@gmail.com' }
  s.source                  = { :git => 'https://github.com/imjerrybao/CMUtils.git', :tag => "#{s.version.to_s}" }
  s.public_header_files     = 'CMUtils/**/*.h'
  s.source_files            = 'CMUtils/**/*.{h,m,c}'
  s.ios.frameworks          = ['UIKit', 'Foundation', 'MapKit', 'ImageIO']
  s.requires_arc            = true
  s.ios.vendored_frameworks = 'CMUtils/Vendor/WebP.framework'
  s.resources               = ['CMUtils/**/*.bundle', 'CMUtils/**/*.png']
  s.dependency              'BlocksKit', '~> 2.2.5'
  s.dependency              'MBProgressHUD', '~> 0.9.1'
  s.dependency              'AFNetworking', '~> 2.5.2'
  s.dependency              'JSONModel', '~> 1.0.2'
  s.dependency              'FMDB', '~> 2.5'
  s.dependency              'DACircularProgress'
  s.dependency              'JKBigInteger', '~> 0.0.1'
  s.dependency              'PEPhotoCropEditor', '~> 1.3.1'
  s.dependency              'Masonry', '~> 0.6.1'
  s.dependency              'pop', '~> 1.0'
end
