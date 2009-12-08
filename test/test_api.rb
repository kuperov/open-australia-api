
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'open-australia/api'
require File.join(File.dirname(__FILE__),'test_helper')

module OpenAustralia

# We won't actually hit the web API during testing
# because I don't want to distribute the API key...
# and it's also poor form in unit tests.
#
# Therefore, we can run tests against URLs requested
# and canned XML instead. Use a dummy mock object to
# work this magic.
class TestApi < Test::Unit::TestCase
  def setup
    @api = Api.new 'DUMMYKEY'
    @api.send(:xml_getter=, DummyXmlGetter.new)
  end
  
  def test_get_divisions
    divs = @api.get_divisions(:search => 'bradfield')
    assert_not_nil divs
  end

  def test_get_debates_reps
    debates = @api.get_debates :search => 'blah', :type => 'representatives'
    assert_not_nil debates
    assert_not_nil debates.info
    assert_not_nil debates.results
  end

  def test_get_debates_senate
    debates = @api.get_debates :search => 'blah', :type => 'senate'
    assert_not_nil debates
    assert_not_nil debates.info
    assert_not_nil debates.results
  end

  def test_get_senator
    senator = @api.get_senator :id => 123
    assert_not_nil senator
    assert_not_nil senator.first_name
  end

  def test_get_senators
    senators = @api.get_senator :id => 123
    assert_not_nil senators
    #assert senators.count > 0
  end

  def test_get_comments
    comments = @api.get_comments :search => 'asdf'
    assert_not_nil comments
    assert_not_nil comments.results
    #assert comments.results.count > 0
  end
end

# mock XmlGetter implementation
class DummyXmlGetter

  def fetch(url)
    if url =~ /\/(get[A-Z]\w+)\?/
      function = $1
      filename = case function
      when "getDivisions" then "division_search_2077.xml"
      when "getDebates" then (url =~ /senate/) ? "debate_search_senate.xml" : "debate_search_reps.xml"
      when "getHansard" then "hansard_utegate_search.xml"
      when "getRepresentatives" then "representatives_search_andrew.xml"
      when "getRepresentative" then "representative_abbott.xml"
      when "getSenator" then "senator_steve_hutchison.xml"
      when "getSenators" then "nsw_senators.xml"
      when "getComments" then "comments.xml"
      end
      absolute = File.join(File.dirname(__FILE__),filename)
      File.open(absolute) do |file|
        return REXML::Document.new file
      end
    else
      return nil
    end
  end
end

end