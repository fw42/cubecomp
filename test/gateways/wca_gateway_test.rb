require 'test_helper'

class WCAGatewayTest < ActiveSupport::TestCase
  setup do
    @wca_api = WCAGateway.new('http://178.62.217.148')
  end

  test '#search_by_id with no results' do
    stub_request(:get, "http://178.62.217.148/competitors?q=2009URAI")
      .to_return(status: 200, body: '{"competitors": []}')

    persons = @wca_api.search_by_id('2009URAI')

    assert_equal [], persons
  end

  test '#search_by_id with several results' do
    body = <<-eos
      {
        "competitors": [
          {"id":"2009URBA01","name":"Micky Urban","gender":"m","country":"Germany"},
          {"id":"2009URBA02","name":"Lucito Urbano","gender":"m","country":"Philippines"},
          {"id":"2009URBI01","name":"Diego Urbina","gender":"m","country":"Chile"}]
      }
    eos
    stub_request(:get, "http://178.62.217.148/competitors?q=2009UR")
      .to_return(status: 200, body: body)

    persons = @wca_api.search_by_id('2009UR')

    assert_equal 3, persons.size
    assert_equal 'Micky Urban', persons.first.name
    assert_equal '2009URBA01', persons.first.id
    assert_equal 'm', persons.first.gender
    assert_equal 'Germany', persons.first.country
  end

  test '#search_by_id with connection error' do
    stub_request(:get, "http://178.62.217.148/competitors?q=2009UR").to_raise(Errno::ECONNREFUSED)
    assert_raises(WCAGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end

  test '#search_by_id with invalid JSON' do
    stub_request(:get, "http://178.62.217.148/competitors?q=2009UR")
      .to_return(status: 200, body: "404")
    assert_raises(WCAGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end

  test '#search_by_id with non-successful response code' do
    stub_request(:get, "http://178.62.217.148/competitors?q=2009UR")
      .to_return(status: 404, body: "{competitors: []}")
    assert_raises(WCAGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end
end
