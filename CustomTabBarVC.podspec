Pod::Spec.new do |spec|
  spec.name             = 'CustomTabBarVC'
  spec.version          = '1.0.2'
  spec.summary          = 'Custom Tab Bar with options for modification.'
 
  spec.description      = <<-DESC
  Library for Custom Tab Bar Controller. Custom options available according to type specified in Custom Tab Bar Params.
                       DESC
 
  spec.homepage         = 'https://github.com/vikramjagad/CustomTabBarVC'
  spec.license          = { :type => 'MIT', :text => 'MIT License

    Copyright (c) 2021 Vikram Jagad

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' }

  spec.author           = { 'Vikram Jagad' => 'vikramjagad97@gmail.com' }
  spec.source           = { :git => 'https://github.com/vikramjagad/CustomTabBarVC.git', :tag => spec.version.to_s }
 
  spec.ios.deployment_target = '11.0'
  spec.source_files     = 'Sources/CustomTabBarVC/**/*'
  spec.swift_version    = '5.0'
 
end
