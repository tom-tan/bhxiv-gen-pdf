# Methods to parse the markdown header

require 'yaml'

class MarkdownError < StandardError
end

def md_parser fn
  yml = YAML.load_file(fn)
  yml
end

def meta_expand(header,event)
  meta = header
  # p header
  # p header["biohackathon_name"]
  # p header[:biohackathon_name]
  if event == :Other
    raise MarkdownError,"biohackathon_name field is missing for 'Other'" if not header["biohackathon_name"]
    raise MarkdownError,"biohackathon_url field is missing for 'Other'" if not header["biohackathon_url"]
    raise MarkdownError,"biohackathon_location field is missing for 'Other'" if not header["biohackathon_location"]
  end
  meta
end

def md_meta_checker(meta)
  raise MarkdownError,"title field is missing" if not meta["title"]
  raise MarkdownError,"tags field is missing" if not meta["tags"]
  raise MarkdownError,"authors field is missing" if not meta["authors"]
  raise MarkdownError,"not enough authors (2 minimum)" if meta["authors"].length < 2
  raise MarkdownError,"group field is missing" if not meta["group"]
  raise MarkdownError,"date field is missing" if not meta["date"]
  raise MarkdownError,"bibliography field is missing" if not meta["cito-bibliography"] and not meta["bibliography"]
  raise MarkdownError,"event field is missing" if not meta["event"]
  raise MarkdownError,"authors_short field is missing" if not meta["authors_short"]
  meta
end

def md_checker fn
  header = md_parser(fn)
  md_meta_checker(header)
end
