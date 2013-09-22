module Arel
  module Attributes
    class Ltree < Struct.new(:query)
      include ::Arel::Ltree::Predications

      def method_missing(name, *args)
        if query.respond_to?(name)
          query.send(name, *args)
        else
          super
        end
      end

      def to_s
        query
      end
    end

    class Lquery < Ltree; end

    Attribute.send :include, Arel::Ltree::Predications
  end
end
