# XML mapping objects for OA queries
# relating to senators

require 'xml/mapping'

module OpenAustralia

#search result for an individual senator
class Senator
  include XML::Mapping

  numeric_node :member_id, 'member_id'
  numeric_node :house, 'house'
  text_node :first_name, 'first_name'
  text_node :last_name, 'last_name'
  text_node :constituency, 'constituency'
  text_node :party, 'party'
  text_node :entered_house, 'entered_house'
  text_node :entered_reason, 'entered_reason'
  text_node :left_house, 'left_house'
  text_node :left_reason, 'left_reason'
  numeric_node :person_id, 'person_id'
  text_node :title, 'title'
  text_node :full_name, 'full_name'
end

# record for foresults of a representative search
class SenatorResult
  include XML::Mapping

  array_node :matches, "result", "match", :class=>Senator, :default_value=>[]
end

# search results for a list of senators
class SenatorFound
  include XML::Mapping

  numeric_node :member_id, 'member_id'
  text_node :name, 'name'
  numeric_node :person_id, 'person_id'
  text_node :party, 'party'
end

# record for foresults of a representative search
class SenatorSearchResult
  include XML::Mapping

  array_node :matches, "result", "match", :class=>SenatorFound, :default_value=>[]
end

end
