# XML mapping classes for OA queries
# relating to debates

require 'xml/mapping'
require 'open-australia/search_info'

module OpenAustralia

  class DebateSearchResult
    include XML::Mapping

    text_node :gid, 'gid'
    text_node :hdate, 'hdate'
    numeric_node :htype, 'htype'
    numeric_node :subsection_id, 'subsection_id'
    numeric_node :relevance, 'relevance'
    numeric_node :speaker_id, 'speaker_id'
    numeric_node :hpos, 'hpos'
    text_node :body, 'body'
    text_node :listurl, 'listurl'

    # FIXME: incomplete 
  end

  class DebateSearch
    include XML::Mapping

    object_node :info, 'info', :class => SearchInfo, :default_value => nil
    text_node :search_description, 'searchdescription', :default_value => nil
    array_node :results, 'rows', 'match', :class => DebateSearchResult, :default_value=>[]
  end
end
