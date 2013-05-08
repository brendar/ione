# encoding: utf-8

module Cql
  class ByteBuffer
    def initialize(initial_bytes='')
      @bytes = initial_bytes.force_encoding(::Encoding::BINARY)
      @offset = 0
    end

    def length
      @bytes.bytesize - @offset
    end
    alias_method :size, :length
    alias_method :bytesize, :length

    def empty?
      length == 0
    end

    def append(bytes)
      bytes = bytes.to_s
      unless bytes.ascii_only?
        bytes = bytes.dup.force_encoding(::Encoding::BINARY)
      end
      @bytes << bytes
      self
    end
    alias_method :<<, :append

    def discard(n)
      @offset += n
    end

    def read_byte
      b = @bytes.getbyte(@offset)
      discard(1)
      b
    end

    def read(n)
      s = @bytes[@offset, n]
      discard(n)
      s
    end

    def [](offset, length=1)
      slice = @bytes[@offset + offset, length]
      self.class.new(slice)
    end

    def eql?(other)
      other.to_str.eql?(self.to_str)
    end
    alias_method :==, :eql?

    def hash
      @bytes.hash
    end

    def dup
      self.class.new(@bytes.dup)
    end

    def to_str
      @bytes[@offset, length]
    end
    alias_method :to_s, :to_str

    def inspect
      %(#<#{self.class.name}: #{to_str.inspect}>)
    end

    def unpack(pattern)
      to_str.unpack(pattern)
    end
  end
end