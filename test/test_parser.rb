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

  def test_yaml_other_empty
    header = md_parser('test/data/yaml1.md')
    assert_raises MarkdownError do
      meta = meta_expand(header,:Other)
    end
    # md_meta_checker(meta)
  end

  def test_yaml_other
    header = md_parser('test/data/other.md')
    meta = meta_expand(header,:Other)
    # p meta
    md_meta_checker(meta)
    assert meta['biohackathon_name'] == "My biohackathon"
  end
end
