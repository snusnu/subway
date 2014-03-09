# encoding: utf-8

require 'pp'
require 'rspec'

require 'subway/entity'

describe 'entity mapping' do

  include Morpher::NodeHelpers

  it 'works for arbitrarily embedded values and collections' do

    # (1) Optionally extend the builtin attribute processors

    processors = Subway::Entity::PROCESSORS.merge(

      Gender: ->(_) {
        s(:guard,
          s(:or,
            s(:eql, s(:input), s(:static, 'M')),
            s(:eql, s(:input), s(:static, 'F'))))
      }

    )

    # (2) Define a new registry of entity definitions

    registry = Subway::Entity::Definition::Registry.build do

      register(:contact) do
        map :email, :String
        map :phone, :String
      end

      register(:task) do
        map :name,          :String
        map :description,   :OString
        map :collaborators, :ParsedInt10Array

        group :labels, entity: :label do
          map :name,  :String
          map :color, :String
        end
      end

      register(:person) do

        map :name,   :String
        map :gender, :Gender

        wrap :contact

        wrap :account do
          map :login,    :String
          map :password, :String
        end

        group :tasks, entity: :task

        group :addresses, entity: :address do
          map :street,  :String
          map :city,    :String
          map :country, :String

          group :tags, entity: :tag do
            map :name, :String
          end
        end
      end
    end

    # (3) Generate model classes for all entities using :anima builder

    models = registry.models(:anima)

    # (4) Create an environment for building models, morphers, mappers
    #     and entities

    environment = registry.environment(models, processors)


    # ----------------------------------------------------------------


    if ENV['LOG']

      puts "\n-------- WORKING WITH MORPHERS ----------\n\n"

    end

    # Some use cases don't require the need to perform
    # a roundtrip (thus needing a mapper). In fact, some
    # transformations are not inversible, and thus don't
    # support roundtrips in the first place. An example
    # would be the s(:merge, {default: :value})) transformer.
    #
    # The example below illustrates a realworld usecase
    # where a pagination (query) parameter may or may not
    # be present, thus requiring a merge operation. It's no
    # problem that this transformation is not inversible,
    # since we don't need to transform the object back into
    # a hash after working with it.

    morpher = environment.morpher(:page) do
      map :page, :ParsedInt10, default: '1'
    end

    begin
      expect(morpher.call({           }).page).to be(1)
      expect(morpher.call('page' => '2').page).to be(2)
    rescue Subway::Entity::Morpher::TransformError => e
      puts e.description
    end

    if ENV['LOG']

      # Something to look at

      input  = {}
      output = morpher.call(input)
      puts "input = #{input.inspect}, output = #{output.inspect}"

      input  = { 'page' => '2' }
      output = morpher.call(input)
      puts "input = #{input.inspect}, output = #{output.inspect}"


      puts "\n-------- WORKING WITH MAPPERS ----------\n\n"

    end

    mapper = environment.mapper(:task)

    hash = {
      'name'          => 'test',
      'description'   => nil,
      'labels'        => [{
        'name'        => 'feature',
        'color'       => 'black'
      }],
      'collaborators' => [ '1' ]
    }

    # Expect it to roundtrip
    expect(mapper.dump(mapper.load(hash))).to eql(hash)

    if ENV['LOG']

      # Something to look at

      task = mapper.load(hash)
      puts "task = #{task.inspect}"

      hash = mapper.dump(task)
      puts "hash = #{hash.inspect}"

      puts "\n-------- WORKING WITH ENTITIES ---------\n\n"

    end

    entities = Subway::Entity.registry(environment)

    entity = entities[:person]

    hash = {
      'name'            => 'snusnu',
      'gender'          => 'M',
      'contact'         => {
        'email'         => 'gamsnjaga@gmail.com',
        'phone'         => '+436505555555'
      },
      'account'         => {
        'login'         => 'snusnu',
        'password'      => 'secret'
      },
      'tasks'           => [{
        'name'          => 'relax',
        'description'   => nil,
        'labels'        => [{
          'name'        => 'feature',
          'color'       => 'green'
        }],
        'collaborators' => [ '1' ]
      }],
      'addresses'       => [{
        'street'        => 'Aglou 23',
        'city'          => 'Aglou',
        'country'       => 'MA',
        'tags'          => [{
          'name'        => 'beach view',
        }]
      }]
    }

    # Expect it to roundtrip
    expect(entity.dump(entity.load(hash))).to eql(hash)

    if ENV['LOG']

      # Something to look at

      person = entity.load(hash)
      puts 'person:'
      pp person

      hash = entity.dump(person)
      puts 'hash:'
      pp hash

      puts "\n------ With failing #load -------\n\n"

      begin
        person = entity.load(something: :bad)
      rescue Subway::Entity::Morpher::TransformError => e
        puts e.description
      end

      puts "\n------ With failing #dump -------\n\n"

      begin
        person = entity.dump(Anima.build(:id).new(id: 1))
      rescue Subway::Entity::Morpher::TransformError => e
        puts e.description
      end

    end
  end
end
