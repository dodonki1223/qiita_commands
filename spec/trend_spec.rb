# frozen_string_literal: true

require 'qiita_trend'
require './spec/spec_helper'
require './qiita_commands/trend'

module QiitaCommands
  describe Trend do
    describe '#initialize' do
      subject(:instance) { described_class.new(type) }

      include_context 'when disable standard output'

      let(:type) { QiitaTrend::TrendType::PERSONAL }

      before { allow(QiitaTrend::Trend).to receive(:new).with(type).and_raise(QiitaTrend::Error::LoginFailureError) }

      it { expect { instance }.to raise_error(SystemExit) }
    end

    context 'when not instance methods' do
      let(:trend_items) do
        [
          {
            'title' => 'サンプルタイトル',
            'user_name' => 'sample',
            'user_image' => 'https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/93703/profile-images/sample',
            'user_page' => 'https://qiita.com/sample',
            'article' => 'https://qiita.com/karamage/items/sample',
            'created_at' => '2020-07-25T08:19:02Z',
            'likes_count' => 300,
            'is_new_arrival' => false
          },
          {
            'title' => 'サンプルタイトル2',
            'user_name' => 'sample2',
            'user_image' => 'https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/93703/profile-images/sample2',
            'user_page' => 'https://qiita.com/sample2',
            'article' => 'https://qiita.com/karamage/items/sample2',
            'created_at' => '2020-07-25T08:19:02Z',
            'likes_count' => 301,
            'is_new_arrival' => false
          }
        ]
      end
      let(:trend_new_items) do
        [
          {
            'title' => 'NEWサンプルタイトル',
            'user_name' => 'new_sample',
            'user_image' => 'https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/93703/profile-images/new_sample',
            'user_page' => 'https://qiita.com/new_sample',
            'article' => 'https://qiita.com/karamage/items/new_sample',
            'created_at' => '2020-07-25T08:19:02Z',
            'likes_count' => 500,
            'is_new_arrival' => true
          },
          {
            'title' => 'NEWサンプルタイトル2',
            'user_name' => 'new_sample2',
            'user_image' => 'https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/93703/profile-images/new_sample2',
            'user_page' => 'https://qiita.com/new_sample2',
            'article' => 'https://qiita.com/karamage/items/new_sample2',
            'created_at' => '2020-07-25T08:19:02Z',
            'likes_count' => 501,
            'is_new_arrival' => true
          }
        ]
      end

      before do
        qiita_trend_mock = instance_double('QiitaTrend::Trend Mock')
        allow(qiita_trend_mock).to receive(:items).and_return(trend_items)
        allow(qiita_trend_mock).to receive(:new_items).and_return(trend_new_items)
        allow(QiitaTrend::Trend).to receive(:new).with(type).and_return(qiita_trend_mock)
      end

      describe '#normal?' do
        let(:trend) { described_class.new(type) }

        context 'when trend type is normal' do
          let(:type) { QiitaTrend::TrendType::NORMAL }

          it { expect(trend.normal?).to eq(true) }
        end

        context 'when trend type is personal' do
          include_context 'when mocking config.yml'
          let(:type) { QiitaTrend::TrendType::PERSONAL }

          it { expect(trend.normal?).to eq(false) }
        end
      end

      describe '#personal?' do
        let(:trend) { described_class.new(type) }

        context 'when trend type is normal' do
          let(:type) { QiitaTrend::TrendType::NORMAL }

          it { expect(trend.personal?).to eq(false) }
        end

        context 'when trend type is personal' do
          include_context 'when mocking config.yml'
          let(:type) { QiitaTrend::TrendType::PERSONAL }

          it { expect(trend.personal?).to eq(true) }
        end
      end

      shared_examples 'contains title and laikes_count and article' do
        include_context 'when mocking config.yml'
        let(:type) { QiitaTrend::TrendType::NORMAL }

        it 'タイトル、いいね数、ページURLが含まれていること' do
          items.each_with_index do |item, index|
            expect(item).to include(result_items[index]['title'])
            expect(item).to include("(#{result_items[index]['likes_count']})")
            expect(item).to include(result_items[index]['article'])
          end
        end
      end

      describe '#items' do
        let(:items) { described_class.new(type).items }
        let(:result_items) { trend_items }

        include_examples 'contains title and laikes_count and article'
      end

      describe '#new_items' do
        let(:items) { described_class.new(type).new_items }
        let(:result_items) { trend_new_items }

        include_examples 'contains title and laikes_count and article'
      end
    end
  end
end
