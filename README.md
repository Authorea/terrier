# Terrier

[![Gem Version](https://badge.fury.io/rb/terrier.svg)](http://badge.fury.io/rb/terrier) [![Build Status](https://travis-ci.org/thewinnower/Terrier.svg?branch=master)](https://travis-ci.org/thewinnower/Terrier)

Terrier is used to retrieve metadata of scholarly works from a variety of sources.

Terrier can be used to pull metadata on any article that has been issued a digital object identifier (DOI) or that is hosted on the Zenodo Repository, maintained by CERN.

With Terrier you can enter any scholarly article URL or DOI to retrieve scholarly information about that article.  Terrier will pull full PDFs of scholarly content if it is hosted on the Zenodo repository.  The production of Terrier was funded by [OpenAire](https://www.openaire.eu/openaire-open-peer-review-tenders) and developed by [The Winnower](thewinnower.com)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terrier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terrier

## Usage

To use Terrier simply call Terrier.new with DOI or zenodo url

#examples

```ruby
Terrier.new('https://zenodo.org/record/32475')
Terrier.new('doi:10.1186/1479-5868-10-79')
```

Terrier returns a hash of information about the document. The keys for which are.

* url
* journal
* title
* authors
* publication_date
* publication_year #Note only returned if document has a DOI
* doi
* issn
* zenodo_pdf: #Note if published on Zenodo and has pdf else this will be nil.
* bibliography

## Contributing

1. Fork it ( https://github.com/thewinnower/terrier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
