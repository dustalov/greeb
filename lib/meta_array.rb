# encoding: utf-8

class MetaArray < Array
  def [] id
    super(id) or begin
      self.class.new.tap do |element|
        self[id] = element
      end
    end
  end
end
