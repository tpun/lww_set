require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  describe '#add' do
    it 'adds element to add_set'
    it 'is idempotent'
  end

  describe '#remove' do
    it 'adds element to remove_set'
  end

  describe '#set' do
    it 'removes previously added element only if removal happens after'
    it 'adds previously removed element only if addition happens after'
    it 'gives bias to addition'
    it 'returns a set'
  end
end
