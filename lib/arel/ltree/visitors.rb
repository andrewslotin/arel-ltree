module Arel
  module Ltree
    module Visitors
      private

      def visit_Arel_Ltree_Nodes_AncestorOf(o, a)
        "#{visit o.left, a} @> #{visit o.right, a}"
      end

      def visit_Arel_Ltree_Nodes_DescendantOf(o, a)
        "#{visit o.left, a} <@ #{visit o.right, a}"
      end

      def visit_Arel_Ltree_Nodes_MatchesLquery(o, a)
        "#{visit o.left, a} ~ #{visit o.right, a}"
      end
    end
  end

  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      include Ltree::Visitors
    end
  end
end
