module Minigrom
  # A base class that uses inheritance to provide grom functionality
  class Base
    attr_reader :raw

    def initialize(statements)
      populate(statements)
    end

    private

    def populate(person_statements)
      person_statements.each do |statement|
        attribute_name = Minigrom::get_id(statement.predicate)
        attribute_value = statement.object.to_s
        instance_variable_set("@#{attribute_name}".to_sym, attribute_value)
      end
    end

    def one_subject_by_predicate(uri)
      pattern = RDF::Query::Pattern.new(:subject, RDF.type, RDF::URI.new(uri))

      subjects = @raw.query(pattern)
      return subjects.first
    end
  end
end
