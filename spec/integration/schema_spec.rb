# encoding: utf-8

require 'spec_helper'

require 'dm-core'
require 'dm-migrations'

require 'axiom'
require 'axiom-do-adapter'

require 'subway/entity'
require 'subway/schema'

describe Subway::Schema do

  # (1) Setup and define tables with DataMapper

  uri = 'postgres://localhost/test'.freeze

  DataMapper.logger = DataMapper::Logger.new($stdout, :debug) if ::ENV['LOG']
  DataMapper.setup(:default, uri)

  class Account
    include DataMapper::Resource

    property :id,    Serial, field: 'account_id'
    property :email, String
  end

  class Person
    include DataMapper::Resource

    property :id,   Serial, field: 'person_id'
    property :name, String

    belongs_to :account
    has n, :tasks
  end

  class Task
    include DataMapper::Resource

    property :id,   Serial, field: 'task_id'
    property :name, String

    belongs_to :person
  end

  DataMapper.finalize.auto_migrate!

  Person.create(
    name:    'snusnu',
    account: { email: 'test@test.com' },
    tasks:   [{name: 'test'}]
  )

  # (2) Initialize a new Subway::Relation::Schema

  models          = DataMapper::Model.descendants
  base_relations  = Subway::Relation::Schema::Builder::DM.call(models)

  relation_schema = Subway::Relation::Schema.build(base_relations) do

    relation :actors do
      people.join(accounts).wrap(account: [:account_id, :email])
    end

    relation :person_details do
      actors.
        join(tasks.rename(name: :task_name)).
        group(tasks: [:task_id, :task_name])

    end

    relation :task_details do
      tasks.
        join(people.rename(name: :person_name)).
        join(accounts).
        wrap(
          account: [:account_id, :email],
          person:  [:person_id, :person_name, :account]
        )
    end

  end

  # (3) Connect the relation schema to a database

  adapter  = Axiom::Adapter::DataObjects.new(uri)
  database = Subway::Database.build(:test, adapter, relation_schema)

  # (4) Define domain DTOs

  entity_registry = Subway::Entity::Definition::Registry.build(guard: false) do

    register :account do
      map :id,    :Integer, from: :account_id
      map :email, :String
    end

    register :person do
      map :id,         :Integer, from: :person_id
      map :account_id, :Integer
      map :name,       :String
    end

    register :task do
      map :id,   :Integer, from: :task_id
      map :name, :String
    end

    register :detailed_person do
      map :id,         :Integer, from: :person_id
      map :name,       :String

      wrap :account, entity: :'detailed_person.account' do
        map :id,    :Integer, from: :account_id
        map :email, :String
      end

      group :tasks, entity: :'detailed_person.task' do
        map :id,   :Integer, from: :task_id
        map :name, :String,  from: :task_name
      end
    end

    register :detailed_task do
      map :id,         :Integer, from: :task_id
      map :name,       :String

      wrap :person, entity: :'task.person' do
        map :id,   :Integer, from: :person_id
        map :name, :String,  from: :person_name

        wrap :account, entity: :'task.person.account' do
          map :id,    :Integer, from: :account_id
          map :email, :String
        end
      end
    end

    register :actor do
      map :id,         :Integer, from: :person_id
      map :name,       :String

      wrap :account, entity: :'actor.account' do
        map :id,       :Integer, from: :account_id
        map :email,    :String
      end
    end

  end

  models   = entity_registry.models(:anima)
  entities = entity_registry.environment(models)

  # (5) Connect schema relations with DTO mappers

  schema = Subway::Schema.build(database, entities) do
    map :accounts,       :account
    map :people,         :person
    map :tasks,          :task
    map :person_details, :detailed_person
    map :task_details,   :detailed_task
    map :actors,         :actor
  end

  it 'provides access to axiom gateway base relations' do

    account = schema[:accounts].sort.one
    expect(account.id).to_not be(nil)
    expect(account.email).to eq('test@test.com')

    person = schema[:people].sort.one
    expect(person.id).to_not be(nil)
    expect(person.name).to eq('snusnu')
    expect(person.account_id).to eql(account.id)

    schema[:accounts].each do |object|
      expect(object.id).to_not be(nil)
      expect(object.email).to eq('test@test.com')
    end

    schema[:people].each do |object|
      expect(object.id).to_not be(nil)
      expect(object.name).to eq('snusnu')
      expect(object.account_id).to eql(account.id)
    end
  end

  it 'provides access to axiom gateway relations' do
    account = schema[:accounts].sort.one
    person  = schema[:people].sort.one
    task    = schema[:tasks].sort.one

    schema[:actors].each do |actor|
      puts actor.inspect
      expect(actor.id).to eq(person.id)
      expect(actor.name).to eq(person.name)
      expect(actor.account.id).to eq(account.id)
      expect(actor.account.email).to eq(account.email)
    end

    schema[:task_details].each do |detailed_task|
      expect(detailed_task.id).to eq(task.id)
      expect(detailed_task.name).to eq(task.name)
      expect(detailed_task.person.id).to eq(person.id)
      expect(detailed_task.person.name).to eq(person.name)
      expect(detailed_task.person.account.id).to eql(account.id)
      expect(detailed_task.person.account.email).to eql(account.email)
    end

    schema[:person_details].each do |detailed_person|
      expect(detailed_person.id).to eq(person.id)
      expect(detailed_person.name).to eq(person.name)
      expect(detailed_person.account.id).to eq(account.id)
      expect(detailed_person.account.email).to eq(account.email)

      detailed_person.tasks.each do |person_task|
        expect(person_task.id).to eq(task.id)
        expect(person_task.name).to eq(task.name)
      end
    end
  end
end
