require 'spec_helper'
require 'parse'
require 'credentials'

describe '#canonicalize_full_link' do
  it 'should replace a local link with a fully qualified one' do
    unqualified = '<a href="item?id=1511">The "Path Patch" Pattern</a>'
    canonicalize_full_link(unqualified).should == "<a href=\"http://awesome.bendyworks.com/item?id=1511\">The \"Path Patch\" Pattern</a>"
  end

  it 'should leave http/s links alone' do
    qualified = '<a href="http://example.com" rel="nofollow">Some Stuff</a>'
    canonicalize_full_link(qualified).should == qualified
  end
end

describe '#canonicalize_link' do
  it 'should replace a local link with a fully-qualified one' do
    link = 'item?id=123'
    canonicalize_link(link).should == "#{HN_URL}/#{link}"
  end

  it 'should leave absolute links untouched' do
    link = 'https://www.example.com/foo?bar=1'
    canonicalize_link(link).should == link
  end
end
