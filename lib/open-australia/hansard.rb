# XML mapping classes for OA Hansard queries

require 'xml/mapping'
require 'open-australia/search_info'

module OpenAustralia

  # office held by a hansard speaker
  class HansardOffice
    include XML::Mapping

    text_node :dept, 'dept'
    text_node :position, 'position'
    text_node :pretty, 'pretty'
  end

  # speaker in a hansard entry (1 per entry)
  class HansardSpeaker
    include XML::Mapping

    numeric_node :member_id, 'member_id'
    text_node :title, 'title'
    text_node :first_name, 'first_name'
    text_node :last_name, 'last_name'
    numeric_node :house, 'house'
    text_node :constituency, 'constituency'
    text_node :party, 'party'
    numeric_node :person_id, 'person_id'
    text_node :url, 'url'
    array_node :offices, 'office', 'match', :class => HansardOffice,
      :default => []
  end

  # search hit for a hansard search
  class Hansard
    include XML::Mapping

    text_node :body, 'body'
    text_node :listurl, 'listurl'
    numeric_node :section_id, 'section_id'
    numeric_node :subsection_id, 'subsection_id'
    numeric_node :relevance, 'relevance'
    numeric_node :speaker_id, 'speaker_id'
    numeric_node :hpos, 'hpos'
    numeric_node :htype, 'htype'
    numeric_node :major, 'major'

    object_node :speaker, 'speaker', :class => HansardSpeaker,
      :default_value => nil

  end

  # hansard query container
  class HansardSearch
    include XML::Mapping

    object_node :info, "info", :class=>SearchInfo, :default_value => nil
    text_node :search_description, 'searchdescription', :deafult_value => nil
    array_node :results, 'rows', 'match', :class => Hansard, :default_value => []
  end
  
end
