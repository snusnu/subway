# encoding: utf-8

require 'spec_helper'

require 'dm-core'
require 'dm-migrations'

require 'axiom'
require 'axiom-do-adapter'
require 'subway/repository'

uri = 'postgres://localhost/test'.freeze
DataMapper.setup(:default, uri)

class Account
  include DataMapper::Resource

  property :id,    Serial
  property :email, String, required: true, unique: true
end

DataMapper.finalize.auto_migrate!

Account.create(email: 'test@test.com')

describe Subway::Repository do

  let(:db) { described_class.build(uri, DataMapper::Model.descendants) }

  it 'provides access to axiom gateway relations' do
    db[:accounts].each do |tuple|
      expect(tuple.to_ary).to include('test@test.com')
    end
  end

end
