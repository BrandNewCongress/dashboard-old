require 'csv'

module Utils
  class GdocReader
    def self.read
      CSV.read('metrics.csv')
    end
  end
end