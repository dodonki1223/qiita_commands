# frozen_string_literal: true

require 'qiita_trend'
require 'highline/import'

module QiitaCommands
  class Trend
    def initialize(type)
      @type     = type
      @highline = HighLine.new
      @target   = QiitaTrend::Trend.new(type)
    rescue QiitaTrend::Error::LoginFailureError => e
      puts highline.color(e.message, :red)
      exit 1
    end

    def normal?
      type == QiitaTrend::TrendType::NORMAL
    end

    def personal?
      type == QiitaTrend::TrendType::PERSONAL
    end

    def items
      target.items.each_with_object([]).with_index { |(item, result), index| result << item_shaping(item, index) }
    end

    def new_items
      return nil if type == QiitaTrend::TrendType::PERSONAL

      target.new_items.each_with_object([]).with_index { |(item, result), index| result << item_shaping(item, index) }
    end

    private

    attr_reader :type, :target, :highline

    def item_shaping(item, index)
      symbolize_item = item.transform_keys(&:to_sym)

      "#{prefix(index)} #{title(symbolize_item[:title])}#{likes_count(symbolize_item[:likes_count])}\n#{article_url(symbolize_item[:article])}"
    end

    def prefix(index)
      format_prefix = "[#{(index + 1).to_s.rjust(2, '0')}]"
      highline.color(format_prefix, :green)
    end

    def title(str)
      highline.color(str, :yellow, :bold)
    end

    def likes_count(count)
      highline.color('(' + count.to_s + ')', :red)
    end

    def article_url(str)
      "     #{highline.color(str, :cyan)}"
    end
  end
end
