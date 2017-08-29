require "minitest/autorun"
require 'rubygems'
require 'vcr'
require 'RestClient'
require "./lib/aemninja.rb"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/aem_responses"
  config.hook_into :webmock
end

class AemninjaTest < Minitest::Test
  def test_aem_is_package_installed?
    aemninja = Aemninja::Application.new

    VCR.use_cassette("list_all_packages") do
      assert_match "adobe/aem6/sample/we.retail.download", aemninja.aem_is_package_installed?("localhost:4502", "admin", "admin", "we.retail.download-1.0.8.zip")
    end
  end
end