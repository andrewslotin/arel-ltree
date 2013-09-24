[![Build Status](https://travis-ci.org/andrewslotin/arel-ltree.png?branch=master)](https://travis-ci.org/andrewslotin/arel-ltree) [![Dependency Status](https://gemnasium.com/andrewslotin/arel-ltree.png)](https://gemnasium.com/andrewslotin/arel-ltree)

# arel-ltree

Arel extension for PostgreSQL ltree type

## Installation

Add this line to your application's Gemfile:

    gem 'arel-ltree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arel-ltree

## Usage

```ruby
Node.where(Node.arel_table[:path].ancestor_of('root.subtree.node')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" @> 'root.subtree.node'::ltree;

Node.where(Node.arel_table[:path].descendant_of('root.subtree')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" <@ 'root.subtree'::ltree;

Node.where(Node.arel_table[:path].matches_ltree('root.subtree')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" ~ 'root.subtree'::ltree;

Node.where(Node.arel_table[:path].matches_lquery('root.*{1}.node')).to_sql
# => SELECT * FROM nodes WHERE "nodes"."path" <@ 'root.*{1}.node'::lquery;
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
