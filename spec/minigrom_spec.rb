require 'spec_helper'

describe Minigrom do
  it 'has a version number' do
    expect(Minigrom::VERSION).not_to be nil
  end

  describe '#process_multiple' do
    before :each do
      class Person < Minigrom::Base
        attr_reader :surname, :forename, :middleName, :gender, :dateOfBirth
      end
    end

    let(:graph) { RDF::Graph.load('spec/fixtures/people.ttl', format: :ttl) }
    let(:uri) { 'http://id.ukpds.org/schema/Person' }

    it 'takes a URI and genereates an array of objects' do


      expect(Minigrom.process_multiple(graph: graph, uri: uri).count).to eq(4581)
    end
  end
end
