# coding: utf-8
require 'spec_helper'
require 'canonical_link_builder'
require 'credentials'
require 'nokogiri'

describe CanonicalLinkBuilder do
  describe '#build_full_link' do
    subject { CanonicalLinkBuilder.build_full_link(nokogiri_link) }

    context 'for a good link text' do
      let(:link_title) { "My sweet blog post" }
      let(:nokogiri_doc) do
        Nokogiri::HTML("<a href=\"example.com\">#{link_title}</a>")
      end

      let(:nokogiri_link) { nokogiri_doc.xpath("//a").first }

      it 'finds the title correctly from the link tag' do
        expect(CanonicalLinkBuilder).to receive(:encode_title).with(link_title)

        subject
      end
    end
  end

  describe '#encode_title' do
    subject { CanonicalLinkBuilder.encode_title(raw_title) }

    context 'simple title' do
      let(:raw_title) { 'UW Big Data Event presents Storm' }
      let(:expected_title) { 'UW Big Data Event presents Storm' }

      it 'does not change the title' do
        expect(subject).to eq expected_title
      end
    end

    context 'title with real apostrophes' do
      let(:raw_title) { 'Study Shows Why It’s Worth Your Employer’s Money To Buy Everyone Walking Desks' }
      let(:expected_title) { "Study Shows Why It&rsquo;s Worth Your Employer&rsquo;s Money To Buy Everyone Walking Desks" }

      it 'escapes the characters' do
        expect(subject).to eq expected_title
      end
    end
  end

  describe '#canonicalize_link' do
    subject { CanonicalLinkBuilder.canonicalize_link(link) }

    context 'with a local link' do
      let(:link) { 'item?id=123' }

      it 'should replace a local link with a fully-qualified one' do
        expect(subject).to eq "#{HN_URL}/#{link}"
      end
    end

    context 'absolute link' do
      let(:link) { 'https://www.example.com/foo?bar=1' }
      it 'leaves the link untouched' do
        expect(subject).to eq link
      end
    end
  end

  describe '#canonical_href_for_link' do
    subject { CanonicalLinkBuilder.canonical_href_for_link(nokogiri_link) }

    context 'for a local link' do
      let(:href) { "item?id=1511" }
      let(:nokogiri_doc) do
        Nokogiri::HTML("<a href=\"#{href}\">The Path Patch Pattern</a>")
      end

      let(:nokogiri_link) { nokogiri_doc.xpath("//a").first }

      it 'replaces the link with a fully qualified one' do
        expect(subject).to eq "http://awesome.bendyworks.com/#{href}"
      end
    end

    context 'given an absolute URL' do
      let(:href) { "http://example.com" }
      let(:nokogiri_doc) do
        Nokogiri::HTML("<a href=\"#{href}\">The Path Patch Pattern</a>")
      end

      let(:nokogiri_link) { nokogiri_doc.xpath("//a").first }

      it 'leaves the href unchanged' do
        expect(subject).to eq href
      end
    end
  end
end
