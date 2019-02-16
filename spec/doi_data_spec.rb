require 'spec_helper'
describe Terrier::DoiData do

  describe 'initalizer' do
    use_vcr_cassette
    it "sets passed in doi as url" do
      terrier = Terrier::DoiData.new('doi:10.1186/1479-5868-10-79')
      expect(terrier.doi).to eq('doi:10.1186/1479-5868-10-79')
    end

  end

  describe 'data' do
    use_vcr_cassette
    it "returns a collection containing the a url" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:url]).to eq('http://dx.doi.org/10.1186/1479-5868-10-79')
    end

    it "returns a collection containing the journal name" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:journal]).to eq('International Journal of Behavioral Nutrition and Physical Activity')
    end

    it "returns a collection containing the journal publisher" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:publisher]).to eq('Springer Nature')
    end

    it "returns a collection containing the journal title" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:title]).to eq('The relationship between cell phone use, physical and sedentary activity, and cardiorespiratory fitness in a sample of U.S. college students')
    end

    it "returns a collection containing a collection of authors" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:authors]).to eq(["Andrew Lepp", "Jacob E Barkley", "Gabriel J Sanders", "Michael Rebold", "Peter Gates"])
    end

    it "returns a collection containing publication year" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:publication_year]).to eq(2013)
    end

    it "returns a collection containing issn" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:issn]).to eq(["1479-5868"])
    end

    it "returns a collection containing a well formed bibliography" do
      expect(Terrier::DoiData.new('doi:10.1186/1479-5868-10-79').data[:bibliography]).to eq("Lepp, A., Barkley, J. E., Sanders, G. J., Rebold, M., & Gates, P. (2013). The relationship between cell phone use, physical and sedentary activity, and cardiorespiratory fitness in a sample of U.S. college students. International Journal of Behavioral Nutrition and Physical Activity, 10(1), 79. <a href=\"https://doi.org/10.1186/1479-5868-10-79\">doi:10.1186/1479-5868-10-79</a>")
    end

  end

end
