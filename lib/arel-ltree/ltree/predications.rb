module Arel
  module Ltree
    module Predications
      def matches_lquery(other)
        case other
        when String
          Arel::Ltree::Nodes::Matches.new(self, Arel::Attributes::Lquery.new(other))
        when Array
          Arel::Ltree::Nodes::Matches.new(self, other.map { |o| Arel::Attributes::Lquery.new(o) })
        else
          Arel::Ltree::Nodes::Matches.new(self, other)
        end
      end

      def matches_ltree(other)
        case other
        when String
          Arel::Ltree::Nodes::Matches.new(self, Arel::Attributes::Ltree.new(other))
        when Array
          Arel::Ltree::Nodes::Matches.new(self, other.map { |o| Arel::Attributes::Ltree.new(o) })
        else
          Arel::Ltree::Nodes::Matches.new(self, other)
        end
      end

      def ancestor_of(other)
        Arel::Ltree::Nodes::AncestorOf.new(self, other)
      end

      def descendant_of(other)
        Arel::Ltree::Nodes::DescendantOf.new(self, other)
      end
    end
  end
end