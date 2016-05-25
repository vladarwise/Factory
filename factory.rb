class Factory
  def self.new(*args, &block)
    Class.new do
      args.each do |arg|
        attr_accessor(arg)
      end
      def initialize(*values)
        values.each_with_index do |val, i|
          send(attr_setter_map[i], val)
        end
      end
      class_eval(&block) if block_given?
      def [](val)
        return self.to_h.values[val] if val.is_a?(Fixnum)
        send(val.to_sym)
      end
      def to_a
        instance_variables.map { |item| send(item.to_s[1..-1]) }
      end
      def to_h
        Hash[instance_variables.zip to_a]
      end
      define_method 'attr_setter_map' do
        self.class.instance_methods(false).map { |args| args if args =~ /=$/ }.compact
      end
    end
  end
end


Customer = Factory.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
puts joe.class
puts joe.name
puts joe["name"]
puts joe[:name]
puts joe[0]

puts joe.name = "Ruby"
puts joe["name"]
puts joe[:name]
puts joe[0]
puts "finish"
