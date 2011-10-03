require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HeatmapFormatter do
  before(:each) do 
    example_data = <<-EOS
      3:0 src/main/resources/com/example/SomeFile.java: DE3981,DE4386
      12:6 src/main/java/com/example/AnotherFile.java: US11743
      6:6 src/main/java/com/example/YetAnotherFile.java: DE3317,DE4077,US12070
    EOS
    
    @input_stream = StringIO.new(example_data)
    @output_stream = StringIO.new

    @formatter = HeatmapFormatter.new("(?<total>(\\d+)):(?<defects>(\\d+)) (?<filename>(.+)):.+",
                                      @input_stream,
                                      @output_stream)
  end
  
  it "Orders the tag cloud based on filename" do
    @formatter.render
    @output_stream.string.should match(".*AnotherFile.*SomeFile.*YetAnotherFile")
  end


  it "Renders each file as a tag" do
    results = @formatter.format_entry 'path/to/SomeFile.java', 3, 0
    results.should match("<li style='.+'>SomeFile.java </li>")
  end 
  
  it "Adds file details to the title attribute for display when hovered over" do
    results = @formatter.format_entry 'src/main/java/com/example/SomeFile.java', 3, 2
    results.should have_title_containing("src/main/java/com/example Changes: 3 Defects: 2")
  end
  
  it "Adjusts the font size of each tag relative to the number of changes in the file" do
    file_with( :changes =>  3 ).should have_font_size(6)
    file_with( :changes =>  6 ).should have_font_size(15)
    file_with( :changes => 12 ).should have_font_size(36)
  end
  
  it "Adjusts the font color of each tag based on the number of changes that were defects" do
    file_with( :changes => 3 ).should have_color('#000000')
  
    file_with( :changes => 3,
               :defects => 3 ).should have_color('#ff0000')
  
    file_with( :changes => 7,
               :defects => 5 ).should have_color('#b60000')
  end
  
  it "Generates a range of font sizes based on a min/max" do
    @formatter.size_for(12).should == 36
    @formatter.size_for(11).should == 30
    @formatter.size_for(8).should  == 21
    @formatter.size_for(7).should  == 18
    @formatter.size_for(4).should  ==  9
    @formatter.size_for(3).should  ==  6
  end
end