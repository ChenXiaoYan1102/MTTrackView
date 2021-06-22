Pod::Spec.new do |s|

  s.name         = "MTTrackView"
  s.version      = "0.0.3"
  s.summary      = "MTTrackView的一个简单示范工程."

  s.description  = <<-DESC
                   传入两个坐标，显示这两个点的轨迹.苹果原生定位实现
                   DESC

  s.homepage     = "https://github.com/ChenXiaoYan1102"

  s.license      = "MIT"

  s.author       = { "Author" => "624122929@qq.com" }

  s.platform     = :ios, "10.0"

  s.source       = { :git => "git@github.com:ChenXiaoYan1102/MTTrackView.git", :tag => "#{s.version}" }

  s.public_header_files = "#{s.name}/*.h", "#{s.name}/include/**/*.h"
  s.source_files = "#{s.name}/**/*.{h,m}"
  s.resource_bundles = {
    "#{s.name}Bundle" => ["#{s.name}Bundle/*"]
  }

end
