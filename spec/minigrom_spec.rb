require 'spec_helper'

describe Minigrom do
  before :each do
    class Person < Minigrom::Base
      attr_reader :surname, :forename, :middleName, :gender, :dateOfBirth
    end
  end

  it 'has a version number' do
    expect(Minigrom::VERSION).not_to be nil
  end

  describe '#process_multiple' do
    let(:graph) { RDF::Graph.load('spec/fixtures/people.ttl', format: :ttl) }
    let(:uri) { 'http://id.ukpds.org/schema/Person' }

    it 'takes a URI and genereates an array of objects' do


      #expect(Minigrom.process_multiple(graph: graph, uri: uri).count).to eq(4581)
    end
  end

  describe '#process_ttl_data' do
    let(:data) { StringIO.new(File.read('spec/fixtures/current_members.ttl')) }

    # it 'populates @statements_by_subject' do
    #   @statements_by_subject, @statements_by_predicate = Minigrom.process_ttl_data(data)
    #
    #   expect(@statements_by_subject.size).to eq(1314)
    # end
    #
    #
    # it 'populates @statements_by_predicate' do
    #   @statements_by_subject, @statements_by_predicate = Minigrom.process_ttl_data(data)
    #
    #   expect(@statements_by_predicate.size).to eq(6)
    # end

    it 'takes ttl data and generates objects from it' do
      expect(Minigrom.process_ttl_data(data).size).to eq(650)
    end
  end
end
