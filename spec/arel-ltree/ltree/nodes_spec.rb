require 'spec_helper'

describe Arel::Ltree::Nodes do
  %w{AncestorOf DescendantOf Matches}.each do |klass_name|
    it "defines a binary operation #{klass_name}" do
      expect(Arel::Ltree::Nodes.const_get(klass_name).superclass).to be Arel::Nodes::Binary
    end
  end
end
