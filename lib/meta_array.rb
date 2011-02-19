# encoding: utf-8

# MetaArray is an Array, which creates subarrays
# on non-existent elements.
#
class MetaArray < Array
  def [] id
    super(id) or begin
      self.class.new.tap do |element|
        self[id] = element
      end
    end
  end
end
