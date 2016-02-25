require 'spec_helper'
describe Terrier do

  describe 'initalizer' do
    use_vcr_cassette
    it "sets passed in arg to indentifier" do
      allow_any_instance_of(Terrier).to receive(:data)
      instance = Terrier.new("blah")
      expect(instance.identifier).to eq("blah")
    end

    it "sets citation_data to {}" do
      allow_any_instance_of(Terrier).to receive(:data)
      instance = Terrier.new("blah")
      expect(instance.citation_data).to eq({})
    end

    it 'calls the internal method data' do
      expect_any_instance_of(Terrier).to receive(:data)
      Terrier.new("blah")
    end

  end

  describe 'data' do
    use_vcr_cassette('data', :record => :new_episodes)

    it "calls html_data if indentifier is a url" do
      expect_any_instance_of(Terrier).to receive(:html_data)
      Terrier.new('https://zenodo.org/record/32475')
    end

    it "does not call html_data if it's a doi indentifier" do
      expect_any_instance_of(Terrier).not_to receive(:html_data)
      Terrier.new('doi:10.1186/1479-5868-10-79')
    end

    it "calls doi_data if indentifier is a doi indentifier" do
      expect_any_instance_of(Terrier).to receive(:doi_data).with('doi:10.1186/1479-5868-10-79')
      Terrier.new('doi:10.1186/1479-5868-10-79')
    end

    it "does not call doi_data if it's a url and doi is not found" do
      allow_any_instance_of(Terrier).to receive(:citation_data).and_return({})
      expect_any_instance_of(Terrier).not_to receive(:doi_data)
      Terrier.new('https://zenodo.org/record/32475')
    end

    it "calls doi_data if it's a url and doi is found" do
      expect_any_instance_of(Terrier).to receive(:doi_data)
      Terrier.new('https://zenodo.org/record/32475')
    end

    it 'merges doi data if found from url' do

       http_data = {
          url: "http://www.example.com/paper/path",
          journal: "The Winnower",
          publication_date: "2015/07/09",
          title: "When Publishers Aren't getting it done.",
          authors: ["Neil  Christensen", "Stacy  Konkiel", "Martin Paul Eve", "Joshua Nicholson", "Lenny  Teytelman"],
          doi: "12345/winn.12345",
          issn: nil,
          zenodo_pdf: "https://zenodo.org/record/22796/files/14th_South_African_Congress_on_Biochemistry_and_Molecular_Biology.pdf",
          bibliography: "Neil  Christensen, Stacy  Konkiel, Martin Paul Eve, Joshua Nicholson, Lenny  Teytelman. (2015/07/09). When Publishers Aren't Getting It Done. The Winnower. DOI: 12345/winn.12345"
        }
        allow_any_instance_of(Terrier::HtmlData).to receive(:data).and_return(http_data)

        doi_data = {
          url: "http://dx.doi.org/10.15200/winn.140832.20404",
          issn: ["2373-146X"],
          journal: "The Winnower, LLC",
          publication_year: 2014,
          title: "The R-Factor: A Measure of Scientific Veracity",
          authors: ["Joshua Nicholson", "Yuri Lazebnik"],
          bibliography: "Neil  Christensen, Stacy  Konkiel, Martin Paul Eve, Joshua Nicholson, Lenny  Teytelman. (2015/07/09). When Publishers Aren't Getting It Done. The Winnower. DOI: 12345/winn.12345"
        }

        allow_any_instance_of(Terrier::DoiData).to receive(:data).and_return(doi_data)
        expect(Terrier.new('https://zenodo.org/record/32475').citation_data).to eq( http_data.merge(doi_data)
          )
    end

  end

end
