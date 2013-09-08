module Arel
  module Ltree
    module Nodes
      %w{
        AncestorOf
        DescendantOf
        MatchesLquery
      }.each do |name|
        const_set name, Class.new(Arel::Nodes::Binary)
      end
    end
  end
end
