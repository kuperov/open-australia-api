# XML mapping classes for OA queries
# relating to debates

require 'xml/mapping'
require 'open-australia/search_info'

module OpenAustralia

  # a record returned by a debate search
  #
  # represents a debate in parliament
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

  # wrapper for debate search results 
  class DebateSearch
    include XML::Mapping

    # general information about the
    # search results
    object_node :info, 'info', :class => SearchInfo, :default_value => nil

    # a human-readable description
    # of the search
    text_node :search_description, 'searchdescription', :default_value => nil

    # search result records
    array_node :results, 'rows', 'match', :class => DebateSearchResult, :default_value=>[]
  end
end
