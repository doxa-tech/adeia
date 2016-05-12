require "adeia/engine"

module Adeia
  @@api_patterns = []
  mattr_accessor :api_patterns

  def self.api_urls=(urls)
    self.api_patterns = urls.map do |url|
      url.gsub(/\//, "\\/").gsub(/\*/, ".*")
    end
  end
end
