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

      def visit_Arel_Ltree_Nodes_MatchesLquery(o)
        "#{visit o.left} ~ #{visit o.right}"
      end

      def visit_Arel_Attributes_Ltree(o)
        "#{quoted(o)}::ltree"
      end

      def visit_Arel_Attributes_Lquery(o)
        "#{quoted(o)}::lquery"
      end
    end
  end

  module Visitors
    PostgreSQL.send :include, Ltree::Visitors
  end
end
