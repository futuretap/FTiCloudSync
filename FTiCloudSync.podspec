Pod::Spec.new do |s|
  s.name     = 'FTiCloudSync'
  s.version  = '0.0.1'
  s.license  = { :type => 'Creative Commons-Attribution-ShareAlike 3.0 Unported', :text => 'You are free to share, adapt and make commercial use of the work as long as\nyou give attribution and keep this license. To give credit, we suggest this\ntext in the about screen or App Store description: \"Uses FTiCloudSync by\nOrtwin Gentz\", with a link to the GitHub page.\n\nIf you need a different license without attribution requirement, please\ncontact me and we can work something out.\n' }
  s.summary  = 'Automatically syncs NSUserDefaults across multiple iOS devices using iCloud'
  s.homepage = 'https://github.com/futuretap/FTiCloudSync'
  s.author   = { 'Luc Vandal' => 'http://www.futuretap.com/contact/',
                  'Ortwin Gentz' => 'http://edovia.com/company/#contact_form' }
  s.source   = { :git => 'https://github.com/futuretap/FTiCloudSync.git', :commit => 'f28114f9ecb838d5fa9076da19e4acf5846d67b3' }
  s.platform = :ios
  s.dependency 'RegexKitLite'
  s.requires_arc = false
  s.source_files = 'NSUserDefaults+iCloud.{h,m}' , 'MethodSwizzling.{c,h}'
end