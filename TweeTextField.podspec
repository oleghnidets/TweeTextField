#
# Be sure to run `pod lib lint TweeTextField.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'TweeTextField'
  s.version          = '1.6.3'
  s.summary          = 'Lightweight set of attributed text fields with nice animation'
  s.description      = <<-DESC
This is lightweight library that provides different types of Text Fields based on your needs. I was inspired by https://uimovement.com/ui/2524/input-field-help/.
                       DESC
  s.homepage         = 'https://github.com/oleghnidets/TweeTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oleg Hnidets' => 'oleg.oleksan@gmail.com' }
  s.source           = { :git => 'https://github.com/oleghnidets/TweeTextField.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true 
  s.source_files     = 'Sources/*.swift'
  s.frameworks       = 'UIKit'
end