require 'rubygems'
require 'open-uri'
require 'cgi'
require 'xml/mapping'
require 'rexml/document'

$:.unshift(File.dirname(__FILE__)+"/..")

require 'open-australia/divisions'
require 'open-australia/representatives'
require 'open-australia/senators'
require 'open-australia/debates'
require 'open-australia/hansard'
require 'open-australia/search_info'
require 'open-australia/comments'

module OpenAustralia

  # Ruby wrapper for the openaustralia.org API
  #
  # You'll need an API key: get one at http://openaustralia.org/api
  #
  class Api

    # create an API instance with the specified key
    # Get your key from http://openaustralia.org/api
    def initialize(key)
      @key = key
      @xml_getter = XmlGetter.new #replaced for unit tests
    end

    # get_divisions returns a list of electoral divisions
    #
    # supported search parameters:
    #  postcode (optional)
    #    Fetch the list of electoral divisions that are within the given
    #    postcode (there can be more than one)
    #  date (optional)
    #    Fetch the list of electoral divisions as it was on this date.
    #  search (optional)
    #    Fetch the list of electoral divisions that match this search string.
    #
    # example:
    #  get_disivions :postcode => 3022
    #
    # NB: at the time of writing, only the postcode parameter seems
    # to actually work.
    def get_divisions(search_params = {})
      xml = do_request('getDivisions', search_params)
      DivisionResult.load_from_xml xml
    end

    # Fetch a particular member of the House of Representatives.
    # 
    # Arguments
    #
    # id (optional)
    #     If you know the person ID for the member you want (returned from
    #     getRepresentatives or elsewhere), this will return data for
    #     that person.
    # division (optional)
    #     The name of an electoral division; we will try and work it out from
    #     whatever you give us. :)
    # always_return (optional)
    #     For the division option, sets whether to always try and return a
    #     Representative, even if the seat is currently vacant.
    #
    # example:
    #     get_representative :id => 10001
    #
    def get_representative(search_params = {})
      xml = do_request('getRepresentative', search_params)
      result = RepresentativeResult.load_from_xml xml
      result.matches.first
    end

    #Fetch a list of members of the House of Representatives.
    #Arguments
    #
    #postcode (optional)
    #    Fetch the list of Representatives whose electoral division lies within
    #    the postcode (there may be more than one)
    #date (optional)
    #    Fetch the list of members of the House of Representatives as it was on
    #    this date.
    #party (optional)
    #    Fetch the list of Representatives from the given party.
    #search (optional)
    #    Fetch the list of Representatives that match this search string in
    #    their name.
    #
    #example
    #    api.get_representatives :postcode => 2000
    #
    #NB: if more than one representative is returned, then the 'office' array
    #    will be empty.
    def get_representatives(search_params = {})
      xml = do_request('getRepresentatives', search_params)
      result = RepresentativeResult.load_from_xml xml
      result.matches
    end

    #Fetch a particular Senator.
    #Arguments
    #
    #id (required)
    #    If you know the person ID for the Senator you want, this will return data for that person.
    #
    #example
    #    api.get_senator :id => 10214
    def get_senator(search_params = {})
      xml = do_request('getSenator', search_params)
      result = SenatorResult.load_from_xml xml
      result.matches.first
    end

    #Fetch a list of Senators.
    #Arguments
    #
    #date (optional)
    #    Fetch the list of Senators as it was on this date.
    #party (optional)
    #    Fetch the list of Senators from the given party.
    #state (optional)
    #    Fetch the list of Senators from the given state.
    #search (optional)
    #    Fetch the list of Senators that match this search string in their name.
    #
    #example
    #    api.get_senators :search => 'brown'
    #
    def get_senators(search_params = {})
      xml = do_request('getSenators', search_params)
      result = SenatorSearchResult.load_from_xml xml
      result.matches
    end
    
    #Fetch Debates.
    #
    #This includes Oral Questions.
    #Arguments
    #
    #Note you can only supply one of the following search terms at present.
    #
    #type (required)
    #    One of "representatives" or "senate". 
    #date
    #    Fetch the debates for this date.
    #search
    #    Fetch the debates that contain this term.
    #person
    #    Fetch the debates by a particular person ID.
    #gid
    #    Fetch the speech or debate that matches this GID.
    #order (optional, when using search or person)
    #    d for date ordering, r for relevance ordering.
    #page (optional, when using search or person)
    #    Page of results to return.
    #num (optional, when using search or person)
    #    Number of results to return.
    def get_debates(search_params = {})
      xml = do_request('getDebates', search_params)
      DebateSearch.load_from_xml xml.root
    end

    #Fetch all Hansard.
    #Arguments
    #
    #Note you can only supply one of the following at present.
    #
    #search
    #    Fetch the data that contain this term.
    #person
    #    Fetch the data by a particular person ID.
    #order (optional, when using search or person, defaults to date)
    #    d for date ordering, r for relevance ordering, p for use by person.
    #page (optional, when using search or person)
    #    Page of results to return.
    #num (optional, when using search or person)
    #    Number of results to return.
    #
    def get_hansard(search_params = {})
      xml = do_request('getHansard', search_params)
      HansardSearch.load_from_xml xml.root
    end

    #Fetch comments left on OpenAustralia.
    #
    #With no arguments, returns most recent comments in reverse date order.
    #Arguments
    #
    #date (optional)
    #    Fetch the comments for this date.
    #search (optional)
    #    Fetch the comments that contain this term.
    #user_id (optional)
    #    Fetch the comments by a particular user ID.
    #pid
    #    Fetch the comments made on a particular person ID (Representative/Senator).
    #page (optional)
    #    Page of results to return.
    #num (optional)
    #    Number of results to return.
    def get_comments(search_params = {})
      xml = do_request('getComments', search_params)
      CommentsSearch.load_from_xml xml
    end

    private

    # process the specified API request,
    # returning XML
    def do_request(command, params)
      url = request_url(command, params)
      @xml_getter.fetch url
    end

    # replace the XML getter with a different one
    # (used by unit tests
    def xml_getter=(getter)
      @xml_getter = getter
    end

    # the URL for the given request
    def request_url(command, params)
      url = "http://www.openaustralia.org/api/#{command}?key=#{@key}&output=xml"
      params.each do |k,v|
        key = CGI::escape(k.to_s)
        value = CGI::escape(v.to_s)
        url += "&#{key}=#{value}"
      end
      url
    end
  end

  # XmlGetter is a dependency for fetching a URL
  # and parsing it as XML. We're using a separate
  # dependency so we can inject a different one
  # for unit testing
  class XmlGetter

    # fetch the specified URL and parse
    # into a REXML document
    def fetch(url)
      open(url) do |f|
        return REXML::Document.new f
      end
    end
    
  end
end