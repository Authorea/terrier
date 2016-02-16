class Terrier::HtmlData
  include HTTParty
  attr_reader :url

  PUBLICATION_META_TAGS = ["citation_journal_title", "dc.publisher", "prism.publicationName"]
  TITLE_META_TAGS = ["citation_title", "dc.title", "prism.title"]
  AUTHOR_META_TAGS = ["citation_author", "dc.creator", "citation_authors", "Authors", "AUTHOR", "creator"]
  PUBLICATION_DATE_META_TAGS = ["citation_publication_date", "publisher", "dc.publisher"]
  DOI_META_TAGS = ["citation_doi", "dc.identifier"]
  LICENSING_TAGS = ["dc.rights"]
  ISSN_TAGS = ["prism.issn"]

  def initialize(url)
    raise Terrier::UrlError, "bad url given" unless uri?(url)
    @url = url
    @raw = self.class.get(url)
    @parsed_html = Nokogiri::HTML(@raw)
  end

  def data
    return @_data if @_data
    @_data = {
      url: url,
      journal: collect_meta_data(@parsed_html, PUBLICATION_META_TAGS).first,
      title: collect_meta_data( @parsed_html, TITLE_META_TAGS).first,
      authors: collect_meta_data( @parsed_html, AUTHOR_META_TAGS).uniq,
      publication_date: collect_meta_data(@parsed_html, PUBLICATION_DATE_META_TAGS).first,
      doi: collect_meta_data(@parsed_html, DOI_META_TAGS).first,
      issn: nil,
      zenodo_pdf: zenodo_pdf
    }

    @_data.merge(bibliography: bibliography(@_data))
  end

  private

  def zenodo_pdf
    @zenodo_pdf ||= /\bhttps:\/\/zenodo.org\S*pdf\b/.match(@raw).to_s
  end

  def bibliography(parsed_data)
    "#{parsed_data[:authors].join(', ')}. (#{parsed_data[:publication_date]}). #{parsed_data[:title]}. #{parsed_data[:journal]}. #{bibliography_reference}"
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  def collect_meta_data(parsed_html, meta_names_array)
    value = []
    meta_names_array.each do |meta_name|
      value = parsed_html.xpath("//meta[@name='#{meta_name}']/@content").map(&:value)
      return value unless value.empty?
    end
    value
  end

  def bibliography_reference
    if data[:doi]
      "<a href='https://doi.org/#{data[:doi]}'>DOI: #{data[:doi]}</a>"
    else
      data[:url]
    end
  end

  def citation_header
    { "Accept" => "application/vnd.citationstyles.csl+json;q=1.0" }
  end
end

class Terrier::UrlError < StandardError
end
