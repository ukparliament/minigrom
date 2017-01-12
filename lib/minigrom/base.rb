module Minigrom
  # A base class that uses inheritance to provide grom functionality
  class Base
    attr_reader :raw

    def initialize(graph: nil, statements: nil)
      graph_and_statements_nil = (graph.nil? && statements.nil?)
      graph_and_statements_present = (!!graph && !!statements)
      raise ArgumentError('Please provice either a graph, or a statement') if graph_and_statements_nil || graph_and_statements_present

      @raw = graph if !!graph

      statements ||= get_statements_from_graph

      populate(statements)
    end

    private

    def get_statements_from_graph
      schema_uri_with_class_name = Minigrom::SCHEMA + self.class.name

      subject = one_subject_by_predicate(schema_uri_with_class_name)

      person_query_pattern = RDF::Query::Pattern.new(subject.subject, :predicate, :object)
      @raw.query(person_query_pattern)
    end

    def populate(person_statements)
      person_statements.each do |statement|
        attribute_name = get_id(statement.predicate)
        attribute_value = statement.object.to_s
        instance_variable_set("@#{attribute_name}".to_sym, attribute_value)
      end
    end

    def get_id(uri)
      Minigrom::get_id(uri)
    end

    def one_subject_by_predicate(uri)
      pattern = RDF::Query::Pattern.new(:subject, RDF.type, RDF::URI.new(uri))

      subjects = @raw.query(pattern)
      return subjects.first
    end
  end
end
