#
# Be sure to run `pod lib lint ToolsFavorites.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ToolsFavorites'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ToolsFavorites.'
  s.homepage         = 'https://github.com/zitao0206/CToolsFavorites'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zitao0206' => '634376133@qq.com' }
  s.source           = { :git => 'https://github.com/zitao0206/CToolsFavorites.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.8'
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '__CUI_MODULE_NAME__=\"CToolsFavorites\" CUI_MODULE_NAME=@\"CToolsFavorites\"'}

  s.source_files = [
    'Classes/**/*'
  ]
  
  s.resource_bundles = {
     'CToolsFavorites' => ['Assets/**/*'],
     'CToolsFavorites-Images' => ['Resources/Images/**/*'],
     'CToolsFavorites-Videos' => ['Resources/Videos/**/*']
  }
#  s.public_header_files = 'CToolsFavorites/Classes/**/*.h'
#  s.prefix_header_file = 'CToolsFavorites.pch'
  s.frameworks = 'UIKit', 'Foundation', 'MapKit'
#  s.dependency 'MarkdownKit'
  s.dependency 'AKOCommonToolsKit'
  s.dependency 'Masonry'
#  s.dependency 'SVProgressHUD'

end
