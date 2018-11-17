#
#  Be sure to run `pod spec lint LHVideoDetailController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name             = 'LHVideoDetailController'
s.version          = '1.0.0'
s.summary          = 'LHVideoDetailController like play video screen of facebook and youtube app'

s.description      = <<-DESC
TODO: LHVideoDetailController like play video screen of facebook and youtube app, LHVideoDetailController allows you to play videos on a floating mini window at the bottom of your screen from sites like YouTube, Vimeo & Facebook or custom video , yes you have to prepare your video view for that.

The controller extend from https://github.com/entotsu/DraggableFloatingViewController

How it works The view will animate the view just like Youtube mobile app, while tapping on video a UIView pops up from right corner of the screen and the view can be dragged to right corner through Pan Gesture and more features are there as Youtube iOS app
DESC

s.homepage         = 'https://github.com/longhoang2984/LHVideoDetailController'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Long Hoàng' => 'longhoang.2984@gmail.com' }
s.source           = { :git => 'https://github.com/longhoang2984/LHVideoDetailController.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
s.platform        = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.swift_version = '4.2'
s.source_files = 'LHVideoDetailController/**/*.swift'
s.frameworks = 'UIKit'

end
