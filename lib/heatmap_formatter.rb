class HeatmapFormatter
  def initialize(line_format, input_stream, output_stream)
    @output_stream = output_stream
    
    format = Regexp.new(line_format)
    
    items_to_render = parse(input_stream, format)
    @entries = items_to_render.sort do | first, second | 
      File.basename(first[:filename]) <=> File.basename(second[:filename])
    end

    @floor, ceiling = (@entries.collect { | e | e[:total].to_i }).minmax
    @range = (ceiling - @floor)
  end
  
  def render
    tags = @entries.inject("") do | result, e |
      result + format_entry(e[:filename], e[:total].to_i, e[:defects]) 
    end

    html = <<-EOS
      <html>
        <head>
          <title>SCM Heatmap</title>
          <style type='text/css'>
              body { font-family: sans-serif; }
              ol li { display: inline; margin: 2px; }
          </style>
        </head>
        <body>
          <ol>
            #{tags}
          </ol>
        </body>
      </html>
    EOS
    
    @output_stream << html
  end
  
  def format_entry(filename, changes, defects)
    style = compute_style(changes, defects)
    title = "#{File.dirname(filename)} Changes: #{changes} Defects: #{defects}"
    "<li style='#{style}' title='#{title}'>#{File.basename(filename)} </li>"
  end
  
  def size_for(number)
    ((((number - @floor).to_f / @range) * 10).to_i * 3) + 6
  end
  
  private

  def parse(stream, format)
    stream.collect() do | line |
      format.match(line)
    end
  end
  
  def compute_style(total_changes, total_defects)
    transparency = calculate_transparency(total_changes, total_defects)
    "font-size: #{size_for(total_changes)}; background-color: rgba(255, 0, 0, #{transparency});"
  end
  
  def determine_relative_size_for(value)
    @size_calculator.size_for(value)
  end
  
  def calculate_transparency(total_changes, total_defects)
    total_defects.to_f / total_changes.to_f
  end
end