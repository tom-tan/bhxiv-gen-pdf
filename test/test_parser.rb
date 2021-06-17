#
# Run with
#
#   ruby -I lib test/test_parser.rb
#
require 'minitest'
require 'minitest/autorun'
require 'bhxiv/markdown'

class TestParser < MiniTest::Test
  def test_yaml_valid
    yml = md_parser('test/data/yaml1.md')
    assert yml['title'] == "Logic Programming for the Biomedical Sciences"
  end

  def test_yaml_complete
    md_checker('test/data/yaml1.md')
  end
end
