# encoding: utf-8

require 'spec_helper'

describe Subway::Pager do
  subject { described_class.new(current_page, max_page, url) }

  let(:url) { 'test' }

  context 'with 1 page' do
    let(:current_page) { 1 }
    let(:max_page)     { 1 }

    its(:prev_class) { should eql('prev disabled') }
    its(:next_class) { should eql('next disabled') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test') }

    its(:pages) {
      should eql([
        { status: 'active', href: 'test', page: 1 }
      ])
    }
  end

  context 'with 2 pages on page 1' do
    let(:current_page) { 1 }
    let(:max_page)     { 2 }

    its(:prev_class) { should eql('prev disabled') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test?page=2') }

    its(:pages) {
      should eql([
        { status: 'active', href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
      ])
    }
  end

  context 'with 2 pages on page 2' do
    let(:current_page) { 2 }
    let(:max_page)     { 2 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next disabled') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test?page=2') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: 'active', href: 'test?page=2', page: 2 },
      ])
    }
  end

  context 'with 3 pages on page 1' do
    let(:current_page) { 1 }
    let(:max_page)     { 3 }

    its(:prev_class) { should eql('prev disabled') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test?page=2') }

    its(:pages) {
      should eql([
        { status: 'active', href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
      ])
    }
  end

  context 'with 3 pages on page 2' do
    let(:current_page) { 2 }
    let(:max_page)     { 3 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test?page=3') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: 'active', href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
      ])
    }
  end

  context 'with 3 pages on page 3' do
    let(:current_page) { 3 }
    let(:max_page)     { 3 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next disabled') }

    its(:prev_href) { should eql('test?page=2') }
    its(:next_href) { should eql('test?page=3') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: 'active', href: 'test?page=3', page: 3 },
      ])
    }
  end

  context 'with 4 pages on page 1' do
    let(:current_page) { 1 }
    let(:max_page)     { 4 }

    its(:prev_class) { should eql('prev disabled') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test') }
    its(:next_href) { should eql('test?page=2') }

    its(:pages) {
      should eql([
        { status: 'active', href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
        { status: '',       href: 'test?page=4', page: 4 },
      ])
    }
  end

  context 'with 4 pages on page 3' do
    let(:current_page) { 3 }
    let(:max_page)     { 4 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test?page=2') }
    its(:next_href) { should eql('test?page=4') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: 'active', href: 'test?page=3', page: 3 },
        { status: '',       href: 'test?page=4', page: 4 },
      ])
    }
  end

  context 'with 4 pages on page 4' do
    let(:current_page) { 4 }
    let(:max_page)     { 4 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next disabled') }

    its(:prev_href) { should eql('test?page=3') }
    its(:next_href) { should eql('test?page=4') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
        { status: 'active', href: 'test?page=4', page: 4 },
      ])
    }
  end

  context 'with 7 pages on page 4' do
    let(:current_page) { 4 }
    let(:max_page)     { 7 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test?page=3') }
    its(:next_href) { should eql('test?page=5') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test',        page: 1 },
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
        { status: 'active', href: 'test?page=4', page: 4 },
        { status: '',       href: 'test?page=5', page: 5 },
        { status: '',       href: 'test?page=6', page: 6 },
        { status: '',       href: 'test?page=7', page: 7 },
      ])
    }
  end

  context 'with 7 pages on page 5' do
    let(:current_page) { 5 }
    let(:max_page)     { 7 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test?page=4') }
    its(:next_href) { should eql('test?page=6') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
        { status: '',       href: 'test?page=4', page: 4 },
        { status: 'active', href: 'test?page=5', page: 5 },
        { status: '',       href: 'test?page=6', page: 6 },
        { status: '',       href: 'test?page=7', page: 7 },
      ])
    }
  end

  context 'with 7 pages on page 6' do
    let(:current_page) { 6 }
    let(:max_page)     { 7 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test?page=5') }
    its(:next_href) { should eql('test?page=7') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test?page=3', page: 3 },
        { status: '',       href: 'test?page=4', page: 4 },
        { status: '',       href: 'test?page=5', page: 5 },
        { status: 'active', href: 'test?page=6', page: 6 },
        { status: '',       href: 'test?page=7', page: 7 },
      ])
    }
  end

  context 'with 10 pages on page 5' do
    let(:current_page) {  5 }
    let(:max_page)     { 10 }

    its(:prev_class) { should eql('prev') }
    its(:next_class) { should eql('next') }

    its(:prev_href) { should eql('test?page=4') }
    its(:next_href) { should eql('test?page=6') }

    its(:pages) {
      should eql([
        { status: '',       href: 'test?page=2', page: 2 },
        { status: '',       href: 'test?page=3', page: 3 },
        { status: '',       href: 'test?page=4', page: 4 },
        { status: 'active', href: 'test?page=5', page: 5 },
        { status: '',       href: 'test?page=6', page: 6 },
        { status: '',       href: 'test?page=7', page: 7 },
        { status: '',       href: 'test?page=8', page: 8 },
      ])
    }
  end
end

