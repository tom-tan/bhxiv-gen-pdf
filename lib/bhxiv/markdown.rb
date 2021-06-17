# Methods to parse the markdown header

require 'yaml'

class MarkdownError < StandardError
end

def md_parser fn
  thing = YAML.load_file('test/data/yaml1.md')
  # $stderr.puts thing.inspect
  thing
end

def md_checker fn
  yml = md_parser(fn)
  raise MarkdownError,"Title missing" if not yml["title"]
end
