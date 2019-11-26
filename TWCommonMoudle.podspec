
Pod::Spec.new do |s|

  s.name         = "TWCommonMoudle"
  s.version      = "1.4.5"
  s.summary      = "A tuyu common  used on iOS."
  s.description  = <<-DESC
                   It is a rich text editor used on iOS, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/1001hotel/TWCommonMoudle"
  s.license      = "MIT"
  s.author             = { "xurenyan" => "812610313@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/1001hotel/TWCommonMoudle.git", :tag => s.version.to_s }

  s.source_files  = "TWCommonMoudle/TWCommonMoudle/*.{h,m,mm}"



  s.vendored_frameworks = "TWCommonMoudle/TWCommonMoudle/AlicloudUtils.framework", "TWCommonMoudle/TWCommonMoudle/AlicloudHttpDNS.framework", "TWCommonMoudle/TWCommonMoudle/UTDID.framework"

 #s.vendored_libraries = '/Pod/Classes/*.a'
 #s.resources = "TWCommonMoudle/TWCommonMoudle/*.xib"
 s.frameworks = "AVFoundation", "SystemConfiguration", "Foundation", "CoreTelephony", "AudioToolbox", "UIKit", "CoreLocation", "Contacts", "AddressBook", "QuartzCore", "CoreGraphics", "MapKit"
 s.libraries = "z", "c++","resolv.9"
 s.dependency "AFNetworking"
 s.dependency "MJRefresh"
 s.dependency "MJExtension"
 s.dependency "MOBFoundation"
 s.dependency "mob_sharesdk"
 s.dependency "mob_sharesdk/ShareSDKPlatforms/QQ"
 s.dependency "mob_sharesdk/ShareSDKPlatforms/SinaWeibo"
 s.dependency "mob_sharesdk/ShareSDKPlatforms/WeChat"
 s.dependency "mob_sharesdk/ShareSDKPlatforms/Facebook"
 s.dependency "mob_sharesdk/ShareSDKPlatforms/Line"
 s.dependency "SDWebImage"
 s.dependency "Qiniu"
 s.dependency "BaiduMobStat"
 s.dependency "TWFreshLoadingView"
 s.dependency "TWAlertMessage"



end
