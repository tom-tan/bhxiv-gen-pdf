# Methods to parse the markdown header

require 'yaml'

class MarkdownError < StandardError
end

def md_parser fn
  yml = YAML.load_file('test/data/yaml1.md')
  yml
end

def md_meta_checker(yml)
  raise MarkdownError,"title field is missing" if not yml["title"]
  raise MarkdownError,"tags field is missing" if not yml["tags"]
  raise MarkdownError,"authors field is missing" if not yml["authors"]
  raise MarkdownError,"not enough authors (2 minimum)" if yml["authors"].length < 2
  raise MarkdownError,"group field is missing" if not yml["group"]
  raise MarkdownError,"date field is missing" if not yml["date"]
  raise MarkdownError,"bibliography field is missing" if not yml["bibliography"]
  raise MarkdownError,"event field is missing" if not yml["event"]
  raise MarkdownError,"authors_short field is missing" if not yml["authors_short"]
  yml
end

def md_checker fn
  yml = md_parser(fn)
  md_meta_checker(yml)
end
