

Pod::Spec.new do |s|

  s.name         = "OCBannerView"
  s.version      = "0.0.1"
  s.summary      = "首页图片轮播控件"
  s.homepage     = "https://github.com/miaozhihui/OCBannerView"
  s.license      = "MIT"
  s.author             = { "miaozhihui" => "876915224@qq.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/miaozhihui/OCBannerView.git", :tag => "#{s.version}" }
  s.source_files  = "BannerView/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "SDWebImage"

end
