module FFI

  # @private
  class Generator

    def initialize(ffi_name, rb_name, options = {})
      @ffi_name = ffi_name
      @rb_name = rb_name
      @options = options
      @name = File.basename rb_name, '.rb'

      file = File.read @ffi_name

      new_file = file.gsub(/^( *)@@@(.*?)@@@/m) do
        @constants = []
        @structs = []

        indent = $1
        original_lines = $2.count "\n"

        instance_eval $2, @ffi_name, $`.count("\n")

        new_lines = []
        @constants.each { |c| new_lines << c.to_ruby }
        @structs.each { |s| new_lines << s.generate_layout }

        new_lines = new_lines.join("\n").split "\n" # expand multiline blocks
        new_lines = new_lines.map { |line| indent + line }

        padding = original_lines - new_lines.length
        new_lines += [nil] * padding if padding >= 0

        new_lines.join "\n"
      end

      open @rb_name, 'w' do |f|
        f.puts "# This file is generated by rake. Do not edit."
        f.puts
        f.puts new_file
      end
    end

    def constants(options = {}, &block)
      @constants << FFI::ConstGenerator.new(@name, @options.merge(options), &block)
    end

    def struct(options = {}, &block)
      @structs << FFI::StructGenerator.new(@name, @options.merge(options), &block)
    end

    ##
    # Utility converter for constants

    def to_s
      proc { |obj| obj.to_s.inspect }
    end

  end
end

