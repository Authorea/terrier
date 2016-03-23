class Terrier::DoiData
  include HTTParty
  attr_reader :doi, :citation_info

  def initialize(doi)
    @doi = doi
  end

  def data
    @citation_info = doi_citation_info
    {
      url: citation_info["URL"],
      journal: citation_info["container-title"],
      publisher: citation_info["publisher"],
      title: citation_info["title"],
      authors: authors,
      publication_year: publication_year,
      issn: citation_info["ISSN"],
      bibliography: bibliography
    }
  end

  private

  def bibliography
    self.class.get("http://dx.doi.org/#{doi}", headers: bibliography_header)
    .strip
    .force_encoding("utf-8")
    .gsub(/(https?:\/\/[\S]+)/, '<a href="\0">\0</a>')
    .gsub(/(doi:[^\s|<|>]+)/, '<a href="\0">\0</a>')
    .gsub('="doi:', '="https://doi.org/')

  end

  def doi_citation_info
    self.class.get("http://dx.doi.org/#{doi}", headers: citation_header, format: :json)
  end

  def bibliography_header
    { "Accept" => "text/x-bibliography; style=apa" }
  end

  def citation_header
    { "Accept" => "application/vnd.citationstyles.csl+json;q=1.0" }
  end

  def authors
    citation_info["author"].map do |author|
      "#{author['given']} #{author['family']}"
    end
  end

  def publication_year
    citation_info["issued"]["raw"] || citation_info["issued"]["date-parts"][0][0]
  end
end
