# frozen_string_literal: true

require File.expand_path('../test_helper', File.dirname(__FILE__))

class ReportHTMLTest < Minitest::Test
  BASE_KEY = Coverband::Adapters::RedisStore::BASE_KEY

  def setup
    @redis = Redis.new
    @store = Coverband::Adapters::RedisStore.new(@redis)
    @store.clear!
  end

  test 'generate scov report' do
    Coverband.configure do |config|
      config.reporter          = 'scov'
      config.store             = @store
      config.s3_bucket         = nil
      config.ignore            = ['notsomething.rb']
    end
    mock_file_hash
    @store.send(:save_report, basic_coverage)

    html = Coverband::Reporters::HTMLReport.report(@store,
                                                       html: true, open_report: false)
    assert_match 'Generated by', html
  end
end
