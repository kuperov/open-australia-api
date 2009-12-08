require 'xml/mapping'

module OpenAustralia
  # debate search info
  class SearchInfo
    include XML::Mapping

    text_node :s, 's', :default_value => nil #what to call this?
    numeric_node :results_per_age, 'results_per_page', :default_value => nil
    numeric_node :page, 'page', :default_value => nil
    numeric_node :total_results, 'total_results', :default_value => nil
    numeric_node :first_result, 'first_result', :default_value => nil
  end
end