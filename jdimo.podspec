Pod::Spec.new do |s|
  s.name         = "jdimo"
  s.version      = "0.1.0"
  s.summary      = "Auto translates NSDictionary to instances of Objective-C classes, supporting nested types and arrays."
  s.homepage     = "https://github.com/Coeur/jdimo"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Antoine Coeur" => "coeur@gmx.fr" }
  s.source       = { :git => "https://github.com/Coeur/jdimo.git", :tag => "0.1.0" }
  s.source_files = 'jdimo/jdimo/*.{h,m}'
end
