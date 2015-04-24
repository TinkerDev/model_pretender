require 'model_pretender/version'
require 'active_record'

class ModelPretender
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  def self.attr_accessor *attrs
    attrs.each do |attr|
      @attribute_keys ||= []
      @attribute_keys << attr.to_s
    end
    super
  end

  def persisted?
    false
  end

  def attributes
    self.class.instance_variable_get(:@attribute_keys).inject({}){|res, key| res[key]=self.send(key);res;}
  end

  def self.boolean_attr_accessor *attrs
    block = ->(value) { ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value) }
    base_attr_accessor *attrs, block
  end

  def self.date_attr_accessor *attrs
    block = ->(value) { ActiveRecord::ConnectionAdapters::Column.value_to_date(value) }
    base_attr_accessor *attrs, block
  end

  def self.time_attr_accessor *attrs
    block = ->(value) { ActiveRecord::ConnectionAdapters::Column.string_to_time(value) }
    base_attr_accessor *attrs, block
  end

  def self.integer_attr_accessor *attrs
    block = ->(value) { ActiveRecord::ConnectionAdapters::Column.value_to_integer(value) }
    base_attr_accessor *attrs, block
  end

  private

  def self.base_attr_accessor *attrs, block
    attr_accessor *attrs
    attrs.each do |attr|
      define_method "#{attr}=" do |value|
        converted_val = block.call(value)
        instance_variable_set(:"@#{attr}", converted_val)
      end
    end
  end
end
