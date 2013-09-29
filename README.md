[![Gem Version](https://badge.fury.io/rb/arel-ltree.png)](http://badge.fury.io/rb/arel-ltree) [![Build Status](https://travis-ci.org/andrewslotin/arel-ltree.png?branch=master)](https://travis-ci.org/andrewslotin/arel-ltree) [![Dependency Status](https://gemnasium.com/andrewslotin/arel-ltree.png)](https://gemnasium.com/andrewslotin/arel-ltree)

# arel-ltree

Arel extension for PostgreSQL [ltree](http://www.postgresql.org/docs/9.2/static/ltree.html) type.

## Installation

Add this line to your application's Gemfile:

    gem 'arel-ltree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arel-ltree

## Usage

Select all parent nodes:
```ruby
Node.where(Node.arel_table[:path].ancestor_of('root.subtree.node')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" @> 'root.subtree.node'::ltree;
```

Select all children nodes:
```ruby
Node.where(Node.arel_table[:path].descendant_of('root.subtree')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" <@ 'root.subtree'::ltree;

Match against ltree:
```ruby
Node.where(Node.arel_table[:path].matches.ltree('root.subtree')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" ~ 'root.subtree'::ltree;

ltree = Arel::Attributes::Ltree.new('root.subtree')
Node.where(Node.arel_table[:path].matches(ltree).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" ~ 'root.subtree'::ltree;
```

Match against lquery (simple regex for ltree):
```ruby
Node.where(Node.arel_table[:path].matches.lquery('root.*{1}.node')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" <@ 'root.*{1}.node'::lquery;

lquery = Arel::Attributes::Lquery.new('root.*{1}.node')
Node.where(Node.arel_table[:path].matches(lquery).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" <@ 'root.*{1}.node'::lquery;
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
