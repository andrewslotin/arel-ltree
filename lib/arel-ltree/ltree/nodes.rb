module Arel
  module Ltree
    module Nodes
      class AncestorOf < ::Arel::Nodes::Binary; end
      class DescendantOf < ::Arel::Nodes::Binary; end
      class MatchesLquery < ::Arel::Nodes::Binary; end
    end
  end
end
