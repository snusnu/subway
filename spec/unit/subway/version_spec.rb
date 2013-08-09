# encoding: utf-8

describe Subway::VERSION do
  it 'defines a VERSION constant' do
    expect { Subway::VERSION }.to_not raise_error
  end
end
