module Arel
  module Ltree
    module Visitors
      private

      def visit_Arel_Ltree_Nodes_AncestorOf(o)
        "#{visit o.left} @> #{visit o.right}"
      end

      def visit_Arel_Ltree_Nodes_DescendantOf(o)
        "#{visit o.left} <@ #{visit o.right}"
      end

      def visit_Arel_Ltree_Nodes_Matches(o)
        raise ArgumentError.new("Missing right operand for MATCH") unless o.right

        if o.right.is_a? Arel::Attributes::Ltxtquery
          "#{visit o.left} @ #{visit o.right}"
        else
          "#{visit o.left} ~ #{visit o.right}"
        end
      end

      def visit_Arel_Ltree_Nodes_MatchesText(o)
        raise ArgumentError.new("Missing right operand for MATCH") unless o.right
        "#{visit o.left} @ #{visit o.right}"
      end

      def visit_Arel_Attributes_Ltree(o)
        "'#{o}'::ltree"
      end

      def visit_Arel_Attributes_Lquery(o)
        "'#{o}'::lquery"
      end

      def visit_Arel_Attributes_Ltxtquery(o)
        quote(o)
      end
    end
  end

  module Visitors
    PostgreSQL.send :include, Ltree::Visitors
  end
end
