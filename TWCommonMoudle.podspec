
Pod::Spec.new do |s|

  s.name         = "TWCommonMoudle"
  s.version      = "0.1.2"
  s.summary      = "A rich text editor used on iOS."
  s.description  = <<-DESC
                   It is a rich text editor used on iOS, which implement by Objective-C.
                   DESC
  s.homepage     = "https://github.com/1001hotel/TWCommonMoudle"
  s.license      = "MIT"
  s.author             = { "xurenyan" => "812610313@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/1001hotel/TWCommonMoudle.git", :tag => s.version.to_s }
  s.source_files  = "TWCommonMoudle/TWCommonMoudle/*.{h,m}"
  #s.vendored_frameworks = "TWRichTextEditor/ThirdParty/iflyMSC.framework", "TWRichTextEditor/ThirdParty/AipBase.framework", "TWRichTextEditor/ThirdParty/AipOcrSdk.framework"
 #s.vendored_libraries = '/Pod/Classes/*.a'
 #s.resources = "TWRichTextEditor/**/*.png", "TWRichTextEditor/**/ZSSRichTextEditor.js", "TWRichTextEditor/**/editor.html", "TWRichTextEditor/**/jQuery.js", "TWRichTextEditor/**/JSBeautifier.js"
 s.frameworks = "AVFoundation", "SystemConfiguration", "Foundation", "CoreTelephony", "AudioToolbox", "UIKit", "CoreLocation", "Contacts", "AddressBook", "QuartzCore", "CoreGraphics"
 s.libraries = "z", "c++"
 s.dependency "AFNetworking", "~> 3.1.0"
 s.dependency "MJRefresh", "~> 2.4.12"
 s.dependency "MJExtension", "~> 3.0.13"
 s.dependency "ShareSDK3", "~> 4.0.0.1"
 s.dependency "MOBFoundation"
 s.dependency "ShareSDK3/ShareSDKPlatforms/QQ"
 s.dependency "ShareSDK3/ShareSDKPlatforms/SinaWeibo"
 s.dependency "ShareSDK3/ShareSDKPlatforms/WeChat"
 s.dependency "ShareSDK3/ShareSDKPlatforms/Facebook"
 s.dependency "ShareSDK3/ShareSDKPlatforms/Line"
 s.dependency "SDWebImage", "~> 3.7.3"
 s.dependency "TWFreshLoadingView", "~> 0.8.0"


end
