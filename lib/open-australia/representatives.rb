# XML mapping classes for OA query results
# relating to representatives

require 'xml/mapping'

module OpenAustralia

# office held by a representative
class RepresentativeOffice
  include XML::Mapping

  text_node :department, 'dept'
  text_node :position, 'position'
  text_node :from_date, 'from_date'
  text_node :to_date, 'to_date'
  text_node :person, 'person'
  text_node :source, 'source'
end

# record for an individual representative
class Representative
  include XML::Mapping

  numeric_node :member_id, 'member_id'
  numeric_node :person_id, 'person_id'
  text_node :constituency, 'constituency'
  text_node :party, 'party'
  numeric_node :house, 'house', :default_value => nil
  text_node :first_name, 'first_name', :default_value => nil
  text_node :last_name, 'last_name', :default_value => nil
  text_node :entered_house, 'entered_house', :default_value => nil
  text_node :entered_reason, 'entered_reason', :default_value => nil
  text_node :left_house, 'left_house', :default_value => nil
  text_node :left_reason, 'left_reason', :default_value => nil
  text_node :title, 'title', :default_value => nil
  text_node :full_name, 'full_name', :default_value => nil
  text_node :name, 'name', :default_value => nil
  text_node :image_url, 'image', :default_value => nil
  array_node :offices, "office", "match", :class=>RepresentativeOffice,
    :default_value =>[]
end

# record for foresults of a representative search
class RepresentativeResult
  include XML::Mapping

  array_node :matches, "result", "match", :class=>Representative,
    :default_value=>[]
end

end
