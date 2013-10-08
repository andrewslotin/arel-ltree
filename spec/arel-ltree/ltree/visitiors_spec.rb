require 'spec_helper'

module Arel
  module Ltree
    describe Visitors do
      subject            { Arel::Visitors::PostgreSQL.new(Arel::Table.engine.connection) }
      let(:parent_ltree) { Arel::Attributes::Ltree.new('1.2') }
      let(:child_ltree)  { Arel::Attributes::Ltree.new('1.2.3') }
      let(:lquery)       { Arel::Attributes::Lquery.new('*.a{2}.b') }
      let(:ltxtquery)    { Arel::Attributes::Ltxtquery.new('1 2') }

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
        node = Nodes::Matches.new(child_ltree, lquery)
        expect(subject.accept(node)).to eq "'1.2.3'::ltree ~ '*.a{2}.b'::lquery"
      end

      it 'supports matching against the ltree' do
        node = Nodes::Matches.new(child_ltree, parent_ltree)
        expect(subject.accept(node)).to eq "'1.2.3'::ltree ~ '1.2'::ltree"
      end

      it 'supports full-text matching' do
        node = Nodes::Matches.new(child_ltree, ltxtquery)
        expect(subject.accept(node)).to eq "'1.2.3'::ltree @ '1 2'"
      end

      context 'with an attribute as a left parameter' do
        let(:table) { Table.new(:nodes) }
        let(:attr)  { table[:path] }
        let(:ltree) { parent_ltree }

        it 'supports ancestor_of operator' do
          node = attr.ancestor_of(ltree)
          expect(subject.accept(node)).to eq %q{"nodes"."path" @> '1.2'::ltree}
        end

        it 'supports descendant_of operator' do
          node = attr.descendant_of(ltree)
          expect(subject.accept(node)).to eq %q{"nodes"."path" <@ '1.2'::ltree}
        end

        describe ".matches" do
          shared_examples_for "performs an ltree match" do
            it "uses ~ as an operator" do
              expect(subject.accept(node)).to match /"nodes"\."path" ~ \S+/
            end
          end

          shared_examples_for "performs a full-text ltree match" do
            it "uses @ as an operator" do
              expect(subject.accept(node)).to match /"nodes"\."path" @ \S+/
            end
          end

          shared_examples_for "performs a string match" do
            it "uses ILIKE as an operator" do
              expect(subject.accept(node)).to match /"nodes"\."path" ILIKE \S+/
            end
          end

          it 'supports matching against the lquery' do
            node = attr.matches.lquery(lquery)
            expect(subject.accept(node)).to eq %q{"nodes"."path" ~ '*.a{2}.b'::lquery}
          end

          it 'supports matching against the ltree' do
            node = attr.matches.ltree(ltree)
            expect(subject.accept(node)).to eq %q{"nodes"."path" ~ '1.2'::ltree}
          end

          it 'raises an ArgumentError' do
            node = attr.matches
            expect { subject.accept(node) }.to raise_error ArgumentError
          end

          it 'can be chained with .ltree' do
            expect { attr.matches.ltree(ltree) }.not_to raise_error NoMethodError
          end

          context "given lquery" do
            let(:node) { attr.matches(lquery) }

            it_should_behave_like "performs an ltree match"
          end

          context "given ltree" do
            let(:node) { attr.matches(ltree) }

            it_should_behave_like "performs an ltree match"
          end

          context "given ltxtquery" do
            let(:node) { attr.matches(ltxtquery) }

            it_should_behave_like "performs a full-text ltree match"
          end

          context "given string" do
            let(:node) { attr.matches("123") }

            it_should_behave_like "performs a string match"
          end

          context "chained with .lquery" do
            let(:node) { attr.matches.lquery("1") }

            it_should_behave_like "performs an ltree match"
          end

          context "chained with .ltree" do
            let(:node) { attr.matches.ltree("1") }

            it_should_behave_like "performs an ltree match"
          end

          context "chained with .ltxtquery" do
            let(:node) { attr.matches.ltxtquery("1") }

            it_should_behave_like "performs a full-text ltree match"
          end
        end
      end
    end
  end
end
