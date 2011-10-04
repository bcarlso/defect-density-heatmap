$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'heatmap_formatter'
require 'command_line_runner'

RSpec.configure do | config |
  config.color_enabled = true
end

RSpec::Matchers.define :have_font_size do | expected |
  match do | actual |
    actual =~ Regexp.new(".*font-size: #{expected};.*")
  end
end

RSpec::Matchers.define :have_color do | expected |
  match do | actual |
    actual =~ Regexp.new(".*color: rgb\\(#{expected}\\);.*")
  end
end

RSpec::Matchers.define :have_title_containing do | expected |
  match do | actual |
    actual =~ Regexp.new(".*title='.*#{expected}.*'.*")
  end
end

def file_with(details)
  @formatter.format_entry 'SomeFile.java', details[:changes], details[:defects] || 0
end

