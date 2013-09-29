module Arel
  module Ltree
    module Nodes
      class AncestorOf < ::Arel::Nodes::Binary; end
      class DescendantOf < ::Arel::Nodes::Binary; end

      class Matches < Arel::Nodes::Binary
        def initialize(left, right = nil)
          super
        end
      end
    end
  end
end
