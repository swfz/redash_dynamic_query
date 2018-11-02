require 'net/https'
require 'json'
module RedashDynamicQuery
  class Client
    attr_reader :api_key, :endpoint, :interval, :timeout

    def initialize(user_apikey:, endpoint:, interval: 0.1, timeout: 10)
      @api_key  = user_apikey
      @endpoint = endpoint
      @interval = interval
      @timeout  = timeout
    end

    def query(query_id:, params:)
      job_id = post_job_request(query_id: query_id, params: params)

      raise 'job_id not fuond.' if job_id.nil?

      query_result_id = poll_job(job_id: job_id)

      raise 'query_result_id not fuond.' if query_result_id.nil?

      get_query_result(query_result_id: query_result_id)
    end

    private

    def post_job_request(query_id:, params:)
      res = with_error_handling do
        Net::HTTP.post_form(
          post_job_url(id: query_id, queries: query_string(params: params)),
          {}
        )
      end

      json = JSON.parse(res.body)
      json.dig('job', 'id')
    end

    def poll_job(job_id:, count: 0)
      res = with_error_handling do
        Net::HTTP.get(poll_job_url(id: job_id))
      end
      id = JSON.parse(res).dig('job', 'query_result_id')

      return id unless id.nil?

      raise "wait timeout with #{timeout} seconds." if reach_limit?(count)

      sleep interval
      poll_job(job_id: job_id, count: count + 1)
    end

    def get_query_result(query_result_id:)
      res = with_error_handling do
        Net::HTTP.get(query_result_url(id: query_result_id))
      end

      JSON.parse(res)
    end

    def post_job_url(id:, queries:)
      URI.parse(
        "#{endpoint}/api/queries/#{id}/refresh?api_key=#{api_key}&#{queries}"
      )
    end

    def poll_job_url(id:)
      URI.parse("#{endpoint}/api/jobs/#{id}?api_key=#{api_key}")
    end

    def query_result_url(id:)
      URI.parse("#{endpoint}/api/query_results/#{id}.json?api_key=#{api_key}")
    end

    def query_string(params:)
      URI.encode_www_form(params.transform_keys { |k| "p_#{k}" })
    end

    def reach_limit?(count)
      count * interval > timeout
    end

    def with_error_handling
      res = yield
      raise res.body if res.is_a? Net::HTTPClientError
      res
    end
  end
end
