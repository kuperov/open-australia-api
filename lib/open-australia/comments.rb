require 'xml/mapping'

module OpenAustralia

  # comments
  class Comments
    include XML::Mapping

    numeric_node :comment_id, 'comment_id'
    numeric_node :user_id, 'user_id'
    text_node :body, 'body'
    text_node :posted, 'posted'
    numeric_node :major, 'major'
    text_node :gid, 'gid'
    text_node :firstname, 'firstname'
    text_node :lastname, 'lastname'
    text_node :url, 'url'
  end
  
  # search results from a comments search
  class CommentsSearch
    include XML::Mapping

    array_node :results, 'comments', 'match', :class => Comments,
      :default_value => []
  end

end