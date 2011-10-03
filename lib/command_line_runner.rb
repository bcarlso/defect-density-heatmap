require 'optparse'
require 'heatmap_formatter'

class CommandLineRunner
  def self.run
    options = {
      :input_stream => STDIN,
      :output_stream => STDOUT,
      :regular_expression => "(?<total>(\\d+)),(?<defects>(\\d+)),(?<filename>(.+))"
    }
    
    OptionParser.new do | opts |
      opts.banner = "Usage: heatmap [options]"

      opts.on("-r", "--record-format pattern", "Regular expression with named captures describing the record") do | regex |
        options[:regular_expression] = regex
      end
      
      opts.on("-f", "--file inputfile", "File containing commit data") do | filename, f2 |
        options[:input_stream] = File.new(filename, 'r')
      end
      
      opts.on("-o", "--outfile outputfile", "File to write output to") do | filename |
        options[:output_stream] = File.new(filename, 'w')
      end
    end.parse!
    
    formatter = HeatmapFormatter.new(options[:regular_expression],
                                     options[:input_stream],
                                     options[:output_stream])
                                     
    formatter.render
  end
end