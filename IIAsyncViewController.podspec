Pod::Spec.new do |s|
  s.name      = 'IIAsyncViewController'
  s.platform  = :ios, 7.0
  s.version   = '1.99.0'
  s.summary   = 'A UIViewController subclass specifically geared toward async data fetching.'
  s.homepage  = 'https://github.com/Inferis/IIAsyncViewController'
  s.license   = { :type => 'MIT', :file => 'LICENSE' }
  s.social_media_url = 'https://twitter.com/inferis'
  s.author    = { 'Tom Adriaenssen' =>  'http://inferis.org/' }
  s.source    = { :git => 'https://github.com/Inferis/IIAsyncViewController.git',
                  :tag => '1.99.0'}
  s.source_files  = 'IIAsyncViewController/**/*.{h,m}'
  s.private_header_files = "IIAsyncViewController/Private/*.h"
  s.requires_arc  = true
end
