#!/usr/bin/env ruby

# Bundler.require(:default)
# require 'zxing'

# print ZXing.decode_all('./10095678.png')

require 'zxing'

print ZXing.decode!( './test_qr.jpeg' )
