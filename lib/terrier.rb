require 'httparty'
require 'nokogiri'
require "terrier/version"
require "terrier/html_data"
require "terrier/doi_data"

class Terrier
  attr_reader :identifier, :citation_data, :zenodo_pdf

  def initialize(identifier)
    @identifier = identifier
    @citation_data = {}
    data
  end

  def data
    if uri?(@identifier)
      html_data
    else
      doi_data(identifier)
    end
  end

  # if the article is pulled by dio and can be found on zenodo we can
  # pull the pdf from the html link.
  # this is a bit unclean
  def zenodo_pdf
    if  citation_data[:zenodo_pdf]
      citation_data[:zenodo_pdf]
    elsif citation_data[:url].include?("zenodo")
       Terrier::HtmlData.new(citation_data[:url]).zenodo_pdf
    end
  end

  private

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  def html_data
    @citation_data = Terrier::HtmlData.new(identifier).data
    if citation_data[:doi]
      doi_data(citation_data[:doi])
    end
  end

  def doi_data(doi)
    fetched_data = Terrier::DoiData.new(doi).data || {}
    @citation_data = @citation_data.merge(fetched_data)
  end

end
