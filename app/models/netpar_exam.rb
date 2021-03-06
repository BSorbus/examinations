require 'net/http'

class NetparExam
	include ActiveModel::Model

  HTTP_ERRORS = [
    EOFError,
    Errno::ECONNRESET,
    Errno::EINVAL,
    Net::HTTPBadResponse,
    Net::HTTPHeaderSyntaxError,
    Net::ProtocolError,
    Timeout::Error,
    Errno::ECONNREFUSED
  ]

	attr_accessor :response, :category, :division_id, :q, :page, :page_limit, :id

  def initialize(params = {})
    @category = params.fetch(:category, '')
    @division_id = params.fetch(:division_id, 0)
    @q = params.fetch(:q, '')
    @page = params.fetch(:page, 0)
    @page_limit = params.fetch(:page_limit, 10)
    @id = params.fetch(:id, 0)
  end

  def request_for_collection
    uri = URI("#{Rails.application.secrets[:netpar2015_api_url]}/exams")
    http = Net::HTTP.new(uri.host, uri.port)
    # SSL 
    http.use_ssl = true if uri.scheme == "https" 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme == "https" # Sets the HTTPS verify mode
    # /SSL 
    req = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json', 'Authorization' => "Token token=#{NetparUser.netparuser_token}"})
    params = {:q => "#{@q}", :page => "#{@page}", :page_limit => "#{@page_limit}", :category => "#{@category}", :division_id => "#{@division_id}"}
    req.body = params.to_json

    @response = http.request(req)

  rescue *HTTP_ERRORS => e
    Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_collection"(1) ==========')
    Rails.logger.error("#{e}")
    Rails.logger.error('=============================================================================')
    errors.add(:base, "API ERROR 'models/netpar_exam .request_for_collection(1) #{Time.zone.now}")
    errors.add(:base, "#{e}")
    false    # non-success response
    #"#{e}"
  rescue StandardError => e
    Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_collection"(2) ==========')
    Rails.logger.error("#{e}")
    Rails.logger.error('=============================================================================')
    errors.add(:base, "API ERROR 'models/netpar_exam .request_for_collection(2) #{Time.zone.now}")
    errors.add(:base, "#{e}")
    false    # non-success response
    #"#{e}"
  else
    case response
    when Net::HTTPOK
      true   # success response
      #response
    when Net::HTTPClientError, Net::HTTPInternalServerError
      Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_collection"(3) ==========')
      Rails.logger.error("code: #{response.code}, message: #{response.message}, body: #{response.body}")
      Rails.logger.error('=============================================================================')
      errors.add(:base, "API ERROR 'models/netpar_exam .request_for_collection(3) #{Time.zone.now}")
      errors.add(:base, "code: #{response.code}, message: #{response.message}, body: #{response.body}")
      false  # non-success response
      #response
    end
  end


  def request_for_one_row
    uri = URI("#{Rails.application.secrets[:netpar2015_api_url]}/exams/#{@id}")
    http = Net::HTTP.new(uri.host, uri.port)
    # SSL 
    http.use_ssl = true if uri.scheme == "https" 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme == "https" # Sets the HTTPS verify mode
    # /SSL 
    req = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json', 'Authorization' => "Token token=#{NetparUser.netparuser_token}"})

    @response = http.request(req)

  rescue *HTTP_ERRORS => e
    Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_one_row"(1) =============')
    Rails.logger.error("#{e}")
    Rails.logger.error('=============================================================================')
    errors.add(:base, "API ERROR 'models/netpar_exam .request_for_one_row'(1) #{Time.zone.now}")
    errors.add(:base, "#{e}")
    false    # non-success response
    #"#{e}"
  rescue StandardError => e
    Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_one_row"(2) =============')
    Rails.logger.error("#{e}")
    Rails.logger.error('=============================================================================')
    errors.add(:base, "API ERROR 'models/netpar_exam .request_for_one_row'(2) #{Time.zone.now}")
    errors.add(:base, "#{e}")
    false    # non-success response
    #"#{e}"
  else
    case response
    when Net::HTTPOK
      true   # success response
      #response
    when Net::HTTPClientError, Net::HTTPInternalServerError
      Rails.logger.error('======== API ERROR "models/netpar_exam .request_for_one_row"(3) =============')
      Rails.logger.error("code: #{response.code}, message: #{response.message}, body: #{response.body}")
      Rails.logger.error('=============================================================================')
      errors.add(:base, "API ERROR 'models/netpar_exam .request_for_one_row'(3) #{Time.zone.now}")
      errors.add(:base, "code: #{response.code}, message: #{response.message}, body: #{response.body}")
      false  # non-success response
      #response
    end
  end

end
