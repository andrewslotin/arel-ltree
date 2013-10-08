module Arel
  module Ltree
    module Predications
      def ancestor_of(other)
        Arel::Ltree::Nodes::AncestorOf.new(self, other)
      end

      def descendant_of(other)
        Arel::Ltree::Nodes::DescendantOf.new(self, other)
      end

      def matches(*args)
        case args[0]
        when Attributes::Ltree
          Arel::Ltree::Nodes::Matches.new(self, args[0])
        when nil
          Arel::Ltree::Nodes::Matches.new(self)
        else
          super
        end
      end
    end

    module MatchesPredications
      def lquery(other)
        ltree_matches_node(other, Attributes::Lquery)
      end

      def ltree(other)
        ltree_matches_node(other, Attributes::Ltree)
      end

      def ltxtquery(other)
        ltree_matches_node(other, Attributes::Ltxtquery)
      end

      private

      def ltree_matches_node(other, rop_node_klass)
        case other
        when String
          Nodes::Matches.new(self.left, rop_node_klass.new(other))
        when Array
          Nodes::Matches.new(self.left, other.map { |o| rop_node_klass.new(o) })
        else
          Nodes::Matches.new(self.left, other)
        end
      end
    end

    Nodes::Matches.send :include, MatchesPredications
  end
end
