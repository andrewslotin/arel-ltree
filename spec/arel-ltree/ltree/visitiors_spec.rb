require 'spec_helper'

module Arel
  module Ltree
    describe Arel::Ltree::Visitors do
      subject            { Arel::Visitors::PostgreSQL.new(Arel::Table.engine.connection) }
      let(:parent_ltree) { Arel::Attributes::Ltree.new('1.2') }
      let(:child_ltree)  { Arel::Attributes::Ltree.new('1.2.3') }
      let(:lquery)       { Arel::Attributes::Lquery.new('*.a{2}.b') }

      it 'visit_Arel_Attributes_Ltree' do
        expect(subject.accept(parent_ltree)).to eq "'1.2'::ltree"
      end

      it 'visit_Arel_Attributes_Lquery' do
        expect(subject.accept(lquery)).to eq "'*.a{2}.b'::lquery"
      end

      it 'supports ancestor_of operator' do
        node = Nodes::AncestorOf.new(parent_ltree, child_ltree)
        expect(subject.accept(node)).to eq "'1.2'::ltree @> '1.2.3'::ltree"
      end

      it 'supports descendant_of operator' do
        node = Nodes::DescendantOf.new(child_ltree, parent_ltree)
        expect(subject.accept(node)).to eq "'1.2.3'::ltree <@ '1.2'::ltree"
      end

      it 'supports matching against the lquery' do
        node = Nodes::MatchesLquery.new(child_ltree, lquery)
        expect(subject.accept(node)).to eq "'1.2.3'::ltree ~ '*.a{2}.b'::lquery"
      end

      context 'with attribute as a left parameter' do
        let(:table) { Table.new(:nodes) }
        let(:attr)  { table[:path] }

        it 'supports ancestor_of operator' do
          node = attr.ancestor_of(parent_ltree)
          expect(subject.accept(node)).to eq %q{"nodes"."path" @> '1.2'::ltree}
        end

        it 'supports descendant_of operator' do
          node = attr.descendant_of(parent_ltree)
          expect(subject.accept(node)).to eq %q{"nodes"."path" <@ '1.2'::ltree}
        end

        it 'supports matching against the lquery' do
          node = attr.matches_lquery(lquery)
          expect(subject.accept(node)).to eq %q{"nodes"."path" ~ '*.a{2}.b'::lquery}
        end
      end
    end
  end
end
