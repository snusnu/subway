# encoding: utf-8

module Subway
  class Pager

    class CssOptions
      include Adamantium, Anima.new(
        :window,
        :prev,
        :prev_disabled,
        :next,
        :next_disabled,
        :current_page
      )
    end

    include Adamantium

    DEFAULT_OPTIONS = CssOptions.new(
      window:        3,
      prev:          'prev',
      prev_disabled: 'prev disabled',
      next:          'next',
      next_disabled: 'next disabled',
      current_page:  'active'
    )

    attr_reader :current_page
    private     :current_page

    attr_reader :max_page
    private     :max_page

    attr_reader :url
    private     :url

    attr_reader :options
    private     :options

    attr_reader :window
    private     :window

    def initialize(current_page, max_page, url, options = DEFAULT_OPTIONS)
      @current_page = current_page
      @max_page     = max_page
      @url          = url
      @options      = options
      @window       = options.window
      @range        = first_page..last_page
    end

    def pages
      @range.map { |page|
        { status: status(page), href: page_url(page), page: page }
      }
    end

    def prev_class
      first_page? ? options.prev_disabled : options.prev
    end

    def next_class
      last_page? ? options.next_disabled : options.next
    end

    def prev_href
      page_url(prev_page)
    end

    def next_href
      page_url(next_page)
    end

    private

    def prev_page
      (page = current_page - 1) > 0 ? page : 1
    end

    def next_page
      (page = current_page + 1) <= max_page ? page : max_page
    end

    def status(page)
      page == current_page ? options.current_page : EMPTY_STRING
    end

    def page_url(page)
      page == 1 ? url : "#{url}?page=#{page}"
    end

    def first_page
      current_page - window > 0 ? current_page - window : 1
    end

    def last_page
      current_page + window <= max_page ? current_page + window : max_page
    end

    def first_page?
      current_page == 1
    end

    def last_page?
      current_page == max_page
    end
  end # Pager
end # Subway
