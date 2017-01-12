require 'spec_helper'
require 'rdf/turtle'
require 'pry'

describe Minigrom::Base do
  describe '#initialize' do
    context 'with a valid graph' do
      before :each do
        class Person < Minigrom::Base
          attr_reader :surname, :forename, :middleName, :gender, :dateOfBirth
        end
      end

      let(:graph) { RDF::Graph.load('spec/fixtures/person.ttl', format: :ttl) }

      subject { Person.new(graph: graph) }

      it 'keeps the `raw` graph data' do
        expect(subject.raw).to eq(graph)
      end

      it 'returns an object withe the expected attributes assigned' do
        expect(subject.dateOfBirth).to eq('1953-09-27')
        expect(subject.forename).to eq('Diane')
        expect(subject.middleName).to eq('Julie')
        expect(subject.surname).to eq('Abbott')
      end
    end

    context 'with an invalid graph' do
      it 'raises a Grom::InvalidGraph exception' do
        pending 'write a test for this'
      end
    end
  end
end
