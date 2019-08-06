require 'spec_helper'
require 'bodega_bot_guesser/generator'

RSpec.describe BodegaBotGuesser::Generator do
  let(:config) do
    BodegaBotGuesser::Generator::Config.new(
      'interns' => %w[a b],
      'product managers' => %w[c d],
      'engineers' => %w[e f g h i],
      'founders' => %w[j],
      'designers' => nil
    )
  end

  subject(:generator) { BodegaBotGuesser::Generator.new(tweet_text, config) }

  describe '#parse_tweet' do
    context 'when the tweet has the right format' do
      # https://twitter.com/BodegaBot/status/1158547791934894081
      let(:tweet_text) { 'These two ex-Lyft interns want to replace herbs & spices stores with pattern recognition' }

      it 'parses out the right matched data' do
        expect(generator.parse_tweet).to eq(BodegaBotGuesser::Generator::ParsedTweet.new('Lyft', 'interns'))
      end
    end

    context 'when the tweet has a multi-word job title' do
      # https://twitter.com/BodegaBot/status/1158412589556219904
      let(:tweet_text) { 'These two ex-Uber product managers want to replace tattoo parlors with signal processing' }

      it 'parses out the right matched data' do
        expect(generator.parse_tweet).to eq(BodegaBotGuesser::Generator::ParsedTweet.new('Uber', 'product managers'))
      end
    end

    context 'when the tweet has an unknown format' do
      let(:tweet_text) { 'This toilet company founded by ex-Square employees' }

      it 'is nil' do
        expect(generator.parse_tweet).to be_nil
      end
    end
  end

  describe '#generate_tweet_text' do
    context 'when there are enough employees' do
      let(:tweet_text) { 'These two ex-Square product managers want' }

      it 'generates a tweet' do
        expect(generator.generate_tweet_text).
          to eq('Hey @c and @d, was this you?').
          or eq('Hey @d and @c, was this you?')
      end
    end

    context 'when the company is not Square' do
      let(:tweet_text) { 'These two ex-Uber engineers want' }

      it 'generates a tweet' do
        expect(generator.generate_tweet_text).to be_nil
      end
    end

    context 'when there are no employees for the role' do
      let(:tweet_text) { 'These two ex-Square founders want' }

      it 'is nil' do
        expect(generator.generate_tweet_text).to be_nil
      end
    end

    context 'when there are not enough employees for the role' do
      let(:tweet_text) { 'These two ex-Square designers' }

      it 'is nil' do
        expect(generator.generate_tweet_text).to be_nil
      end
    end
  end

  describe BodegaBotGuesser::Generator::Config do
    describe '.default' do
      it 'loads' do
        expect(BodegaBotGuesser::Generator::Config.default).to be
      end
    end
  end
end
