Pod::Spec.new do |s|
  s.name                = "DVDropdownMenu"
  s.version             = "0.0.1"
  s.summary             = "Dropdown menu for UINavigationBar"
  s.homepage            = 'https://github.com/denis-vashkovski/DVDropdownMenu'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.authors             = { 'Denis Vashkovski' => 'denis.vashkovski.vv@gmail.com' }
  s.platform            = :ios, "7.1"
  s.source              = { :git => 'https://github.com/denis-vashkovski/DVDropdownMenu.git', :tag => s.version.to_s }
  s.ios.source_files    = 'DVDropdownMenu/DVDropdownMenuItem.{h,m}',
                          'DVDropdownMenu/UINavigationController+DVDropdownMenu.{h,m}'
  s.requires_arc        = true
end
