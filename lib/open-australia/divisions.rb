# XML mapping classes relating to divisions
# for OA queries

require 'xml/mapping'

module OpenAustralia

  # a record for a division search
  class DivisionMatch
    include XML::Mapping

    text_node :name, "name"
  end

  # a resultset for a division search
  class DivisionResult
    include XML::Mapping

    array_node :matches, "", "match", :class=>DivisionMatch, :default_value=>[]
  end

end