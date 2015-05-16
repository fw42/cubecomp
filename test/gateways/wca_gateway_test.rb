require 'test_helper'

class WcaGatewayTest < ActiveSupport::TestCase
  setup do
    @wca_api = WcaGateway.new('http://some-wca-api-url')
  end

  test '#search_by_id with no results' do
    stub_request(:get, "http://some-wca-api-url/competitors?q=2009URAI")
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
    stub_request(:get, "http://some-wca-api-url/competitors?q=2009UR")
      .to_return(status: 200, body: body)

    persons = @wca_api.search_by_id('2009UR')

    assert_equal 3, persons.size
    assert_equal 'Micky Urban', persons.first.name
    assert_equal '2009URBA01', persons.first.id
    assert_equal 'm', persons.first.gender
    assert_equal 'Germany', persons.first.country
  end

  test '#search_by_id with connection error' do
    stub_request(:get, "http://some-wca-api-url/competitors?q=2009UR").to_raise(Errno::ECONNREFUSED)
    assert_raises(WcaGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end

  test '#search_by_id with invalid JSON' do
    stub_request(:get, "http://some-wca-api-url/competitors?q=2009UR")
      .to_return(status: 200, body: "404")
    assert_raises(WcaGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end

  test '#search_by_id with non-successful response code' do
    stub_request(:get, "http://some-wca-api-url/competitors?q=2009UR")
      .to_return(status: 404, body: "{competitors: []}")
    assert_raises(WcaGateway::ConnectionError) do
      @wca_api.search_by_id('2009UR')
    end
  end

  test '#find_by_id with result' do
    body = <<-eos
      {
        "competitor":
          {"id":"2003POCH01","name":"Micky Urban","gender":"m","country":"Germany", "competition_count": 43}
      }
    eos

    stub_request(:get, "http://some-wca-api-url/competitors/2003POCH01")
      .to_return(status: 200, body: body)

    assert_equal @wca_api.find_by_id('2003POCH01').competition_count, 43
  end

  test '#find_by_id with 404' do
    body = <<-eos
      {
        "error": "not found"
      }
    eos

    stub_request(:get, "http://some-wca-api-url/competitors/2003POCH01")
      .to_return(status: 404, body: body)

    assert_equal @wca_api.find_by_id('2003POCH01'), nil
  end

  test '#find_records_for' do
    body = <<-eos
    {
      "666":{
        "single":{
          "time":27509
        },
        "average":{
          "time":32728
        }
      },
      "444bf":{
        "single":{
          "time":40100
        },
        "average":null
      },
      "555bf":{
        "single":{
          "time":78000
        },
        "average":null
      }
    }
    eos

    stub_request(:get, "http://some-wca-api-url/competitors/2003POCH01/records")
      .to_return(status: 200, body: body)

    assert_equal @wca_api.find_records_for('2003POCH01', '666').single, 27509
    assert_equal @wca_api.find_records_for('2003POCH01', '666').average, 32728
  end

  test '#find_records_for with missing record' do
    body = <<-eos
    {
      "666":{
        "single":{
          "time":27509
        },
        "average":{
          "time":32728
        }
      },
      "444bf":{
        "single":{
          "time":40100
        },
        "average":null
      },
      "555bf":{
        "single":{
          "time":78000
        },
        "average":null
      }
    }
    eos

    stub_request(:get, "http://some-wca-api-url/competitors/2003POCH01/records")
      .to_return(status: 200, body: body)

    assert_equal @wca_api.find_records_for('2003POCH01', '777').single, nil
    assert_equal @wca_api.find_records_for('2003POCH01', '777').average, nil
  end

  test '#find_records_for with just single record' do
    body = <<-eos
    {
      "666":{
        "single":{
          "time":27509
        },
        "average":{
          "time":32728
        }
      },
      "444bf":{
        "single":{
          "time":40100
        },
        "average":null
      },
      "555bf":{
        "single":{
          "time":78000
        },
        "average":null
      }
    }
    eos

    stub_request(:get, "http://some-wca-api-url/competitors/2003POCH01/records")
      .to_return(status: 200, body: body)

    assert_equal @wca_api.find_records_for('2003POCH01', '444bf').single, 40100
    assert_equal @wca_api.find_records_for('2003POCH01', '444bf').single?, true
    assert_equal @wca_api.find_records_for('2003POCH01', '444bf').average, nil
    assert_equal @wca_api.find_records_for('2003POCH01', '444bf').average?, false
  end
end
