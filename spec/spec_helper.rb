require 'bundler/setup'
Bundler.setup

require 'terrier' # and any other gems you need
require 'vcr'

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.default_cassette_options = {
    :re_record_interval => 604800
  }
end
