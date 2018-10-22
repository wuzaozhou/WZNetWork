#
# Be sure to run `pod lib lint HZFrameWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HZFrameWork'
  s.version          = '1.0.3'
  s.summary          = '花镇封装私有库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
花镇封装私有库  共有部分组件化管理
                       DESC

  s.homepage         = 'https://git.coding.net/Runya_lsj/HZFrameWork.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Runyalsj' => 'Runya_lsj@163.com' }
  s.source           = { :git => 'https://git.coding.net/Runya_lsj/HZFrameWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'HZEmptyView' do |c|
    c.source_files = 'HZFrameWork/Classes/HZEmptyView/**/*'
    c.dependency  'Masonry'
  end
#网络相关 SDWebimage  AFNetworking
  s.subspec 'HZNetworking' do |n|
    n.source_files = 'HZFrameWork/Classes/HZNetworking/**/*'
    n.dependency  'AFNetworking'
  end

  #s.source_files = 'HZFrameWork/Classes/**/*'
  
   s.resource_bundles = {
     'HZFrameWork' => ['HZFrameWork/Assets/*.png']
   }
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SDWebImage'
end
