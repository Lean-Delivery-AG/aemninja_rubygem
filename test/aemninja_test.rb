require "minitest/autorun"
require 'rubygems'
require 'vcr'
require 'RestClient'
require "./lib/aemninja/aem.rb"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/aem_responses"
  config.hook_into :webmock
end

class AemTest < Minitest::Test
  def test_is_package_installed?
    VCR.use_cassette("list_all_packages") do
      assert_match "adobe/aem6/sample/we.retail.download", Aem.is_package_installed?("localhost:4502", "admin", "admin", "we.retail.download-1.0.8.zip")
    end
  end
  def test_uninstall
    VCR.use_cassette("uninstall") do
      assert Aem.uninstall("localhost:4502", "admin", "admin", "adobe/aem6/sample/we.retail.download-1.0.8.zip")
    end
  end
  def test_delete
    VCR.use_cassette("delete") do
      assert Aem.delete("localhost:4502", "admin", "admin", "adobe/aem6/sample/we.retail.download-1.0.8.zip")
    end
  end
  def test_install
    VCR.use_cassette("install") do
      assert Aem.install("localhost:4502", "admin", "admin", "test/aem/we.retail.download-1.0.8.zip")
    end
  end
end