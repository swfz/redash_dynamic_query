require 'net/https'
require 'json'
module RedashDynamicQuery
  class Client
    attr_reader :api_key, :endpoint, :wait_interval

    def initialize(user_apikey:, endpoint:, wait_interval: 0.1)
      @api_key = user_apikey
      @endpoint = endpoint
      @wait_interval = wait_interval
    end

    def query(query_id:, params:)
      job_id = post_job_request(query_id: query_id, params: params)

      query_result_id = poll_job(job_id: job_id)

      get_query_result(query_result_id: query_result_id)
    end

    private

    def post_job_request(query_id:, params:)
      query_string = URI.encode_www_form(params.transform_keys { |k| "p_#{k}" })
      url = "#{endpoint}/api/queries/#{query_id}/refresh?api_key=#{api_key}&#{query_string}"
      res = Net::HTTP.post_form(URI.parse(url), {})
      json = JSON.parse(res.body)
      json.dig('job','id')
    end

    def get_query_result(query_result_id:)
      url = "#{endpoint}/api/query_results/#{query_result_id}.json?api_key=#{api_key}"
      res = Net::HTTP.get(URI.parse(url))
      JSON.parse(res)
    end

    def poll_job(job_id:)
      url = "#{endpoint}/api/jobs/#{job_id}?api_key=#{api_key}"
      res = Net::HTTP.get(URI.parse(url))
      id = JSON.parse(res).dig('job', 'query_result_id')

      if id.nil?
        sleep wait_interval
        poll_job(job_id: job_id)
      else
        id
      end
    end
  end
end
