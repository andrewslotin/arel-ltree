module Arel
  module Attributes
    class Ltree < Attribute; end
    class Lquery < Attribute; end

    class Attribute < Struct.new(:relation, :name)
      include Arel::Ltree::Predications
    end
  end
end
