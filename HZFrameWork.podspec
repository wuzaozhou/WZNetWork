#
# Be sure to run `pod lib lint HZFrameWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HZFrameWork'
  s.version          = '1.3.4'
  s.summary          = '花镇封装私有库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
花镇封装私有库  共有部分组件化管理
                       DESC

  s.homepage         = 'https://git.dev.tencent.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Runyalsj' => 'Runya_lsj@163.com' }
  s.source           = { :git => 'https://git.dev.tencent.com/paoxue/HZFrameWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'HZEmptyView' do |c|
    c.source_files = 'HZFrameWork/HZEmptyView/**/*'
    
  end
#网络相关 SDWebimage  AFNetworking
  s.subspec 'HZNetworking' do |p|
    p.source_files = 'HZFrameWork/HZNetworking/**/*'
    p.dependency  'AFNetworking'
  end

  #标题滚动相关 
  s.subspec 'HZPageView' do |p|
    p.source_files = 'HZFrameWork/HZPageView/**/*'
  end

  #图片浏览器相关
  s.subspec 'HZPhotoBrowser' do |p|
    p.source_files = 'HZFrameWork/HZPhotoBrowser/**/*'
  end
  
  #工具相关
  s.subspec 'HZTool' do |p|
      p.source_files = 'HZFrameWork/HZTool/**/*'
  end
  
  #FPS相关
  s.subspec 'HZFPS' do |p|
      p.source_files = 'HZFrameWork/HZFPS/**/*'
  end
  
  #loading相关
  s.subspec 'HZHUD' do |p|
    p.source_files = 'HZFrameWork/HZHUD/**/*'
    p.dependency  'MBProgressHUD'
  end
  
  #字体设置相关
  s.subspec 'HZFontFile' do |p|
      p.source_files = 'HZFrameWork/HZFontFile/**/*'
  end

  #字体设置相关
  s.subspec 'HZPopView' do |p|
  p.source_files = 'HZFrameWork/HZPopView/**/*'
  end


  #s.source_files = 'HZFrameWork/Classes/**/*'
  
  s.resource_bundles = {
    'HZFrameWork' => ['HZFrameWork/Assets/*.png']
  }
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SDWebImage'
  s.dependency 'YYKit'
  s.dependency 'Masonry'
end
