require "minitest/autorun"
require "./lib/aemninja/helpers.rb"
require 'fileutils'

class HelpersTest < Minitest::Test

  def test_create_directory
    assert_output(/create/) do
      Aemninja::Helpers::create_directory("test-directory")
    end
    assert File.directory? "test-directory"

    # Clean Up
    FileUtils.remove_dir "test-directory"
  end

  def test_create_file
    assert_output(/create/) do
      Aemninja::Helpers::create_file("test-file")
    end
    assert File.file? "test-file"

    # Clean Up
    FileUtils.remove_file "test-file"
  end

  def test_remove_path_from_package
    assert_equal "my-fancy-aem-package-1.0.0.zip", Aemninja::Helpers::remove_path_from("/path/to/package/my-fancy-aem-package-1.0.0.zip")
  end

  def test_remove_version_from_package
    assert_equal "/path/to/package/my-fancy-aem-package-", Aemninja::Helpers::remove_version_from("/path/to/package/my-fancy-aem-package-1.0.0.zip")
  end

  def test_remove_path_and_version_from_package
    assert_equal "my-fancy-aem-package-", Aemninja::Helpers::remove_path_and_version_from("/path/to/package/my-fancy-aem-package-1.0.0.zip")
  end

end