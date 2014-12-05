require 'spec_helper'
require 'model_pretender'
describe ModelPretender do
  it "make things right" do
    class TestClass < ModelPretender
      boolean_attr_accessor :boolean
      date_attr_accessor :date
      time_attr_accessor :time
      integer_attr_accessor :integer
    end

    time = Time.now
    date = Date.today

    test=TestClass.new(
      {
        :boolean=>'1',
        :date=>date.to_s,
        :time => time.to_s,
        :integer => '3'
      }
    )

    test.boolean.should == true
    test.date.should == date
    test.time.to_s == time.to_s
    test.integer.should == 3
  end
end