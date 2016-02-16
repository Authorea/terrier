require 'spec_helper'
describe Terrier::HtmlData do

  describe 'initalizer' do
    use_vcr_cassette
    it "sets passed in arg as url" do
      terrier = Terrier::HtmlData.new('http://www.example.com')
      expect(terrier.url).to eq('http://www.example.com')
    end

    it "return string if bad url is sent in" do
      expect { Terrier::HtmlData.new('htasdasd:/asdsad,sd') }.to raise_error(Terrier::UrlError)
    end

  end

  describe 'data' do
    use_vcr_cassette('htmldata_data', :record => :new_episodes)
    it "returns a collection containing the original url" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32475').data[:url]).to eq('https://zenodo.org/record/32475')
    end

    it "returns a collection containing the journal meta tags if they exist" do
      pending("need zendo with journal meta tags")
      expect(Terrier::HtmlData.new('https://zenodo.org/record/46077?ln=en').data[:journal]).to eq(nil)
    end

    it "returns a collection containing the journal title" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32481?ln=en').data[:title]).to eq('Big and Smart Data Analytics - Possible Advantages to Clinical Practice')
    end

    it "returns a collection containing a collection of authors" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32481?ln=en').data[:authors]).to eq(["Di Meglio, Alberto", "Manca, Marco"])
    end

    it "returns a collection containing publication_date" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32481?ln=en').data[:publication_date]).to eq("2015/10/20")
    end

    it "returns a collection containing the doi" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32481?ln=en').data[:doi]).to eq("10.5281/zenodo.32481")
    end

    it "returns a collection containing the pdf if it exists on zendo" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/46067?ln=en').data[:zenodo_pdf]).to eq('https://zenodo.org/record/46067/files/article.pdf')
    end


    it "returns a collection containing the issn" do
      pending("need zendo with isn")
      expect(Terrier::HtmlData.new('https://zenodo.org/record/46077?ln=en').data[:issn]).to eq(nil)
    end

    it "returns a collection containing a well formed bibliography" do
      expect(Terrier::HtmlData.new('https://zenodo.org/record/32481?ln=en').data[:bibliography]).to eq("Di Meglio, Alberto, Manca, Marco. (2015/10/20). Big and Smart Data Analytics - Possible Advantages to Clinical Practice. . <a href='https://doi.org/10.5281/zenodo.32481'>DOI: 10.5281/zenodo.32481</a>")
    end

  end

end