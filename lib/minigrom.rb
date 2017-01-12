require 'minigrom/version'
require 'minigrom/base'
require 'rdf/turtle'

# A 'mini' implementation of GROM that will be used for researching algorithms
module Minigrom
  # What schema are our objects based on?
  SCHEMA = 'http://id.ukpds.org/schema/'.freeze

  def self.process_multiple(graph: graph, uri: uri)
    # Create URI
    # Get all sbjects with that type
    # Get all statements for all subjects
    # Create people
    object_uri = RDF::URI.new(uri)
    object_subjects_pattern = RDF::Query::Pattern.new(:subject, RDF.type, object_uri)
    object_class = Object.const_get(Minigrom::get_id(object_uri))

    object_subjects = graph.query(object_subjects_pattern)

    object_subjects.map do |object_subject|
      object_statements_pattern = RDF::Query::Pattern.new(object_subject.subject, :predicate, :object)

      object_statements = graph.query(object_statements_pattern)

      object_class.new(statements: object_statements)
    end
  end

  def self.process_ttl_data(data)
    @statements_by_subject = {}
    # @statements_by_predicate = {}
    @type_by_subject = {}
    @subjects = Set.new
    @objects = []

    type_uri = RDF.type.to_s

    # iterate through and stream things
    RDF::Turtle::Reader.new(data) do |reader|
      reader.each_statement do |statement|
        subject = statement.subject.to_s
        @subjects.add(subject)
        @statements_by_subject[subject] ||= []
        @statements_by_subject[subject] << statement

        predicate = statement.predicate.to_s
        # @statements_by_predicate[predicate] ||= []
        # @statements_by_predicate[predicate] << statement

        # is this statement a type definition?
        if predicate == type_uri # && !['HouseOfCommons'].include?(statement.object)
          @type_by_subject[subject] = get_id(statement.object)
        end
      end
    end

    @subjects.each do |subject|
      begin
        # create whatever class is in the hash
        class_name = Object.const_get(@type_by_subject[subject])

        @objects << class_name.new(@statements_by_subject[subject])
      rescue
      end
    end

    @objects
  end

  def self.get_id(uri)
    uri == RDF.type.to_s ? 'type' : uri.to_s.split('/').last
  end
end
