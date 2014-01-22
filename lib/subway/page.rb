# encoding: utf-8

module Subway

  class Page

    include Concord.new(:number, :nr_of_pages, :items)
    include Lupo.enumerable(:items)

    public :number, :nr_of_pages

  end # Page
end # Subway
