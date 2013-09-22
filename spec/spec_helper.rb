require 'arel-ltree'
require 'support/fake_record'

Arel::Table.engine = Arel::Sql::Engine.new(FakeRecord::Base.new)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
