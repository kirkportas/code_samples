require 'singleton'

module GtaClient
  class Client
    include HTTParty
    include Singleton

    attr_accessor :client_id, :email, :password, :api_url, :request_mode, :response_url

    def initialize(args = {})
      setup(args)
    end

    # Setup GTA client with default credentials
    def setup(args = {})
      self.client_id    = args[:client_id] || '82'
      self.email        = args[:email] || 'XML.JINEE@CELESTIALVOYAGERS.COM'
      self.password     = args[:password] || 'PASS'
      self.api_url      = args[:api_url] || 'https://interface.demo.gta-travel.com/rbsusapi/RequestListenerServlet'
      self.request_mode = args[:request_mode] || GtaConstant::REQUEST_MODE::SYNCHRONOUS
      self.response_url = args[:response_url] || '/'
    end

    # The Source element is required to identify and authenticate the requestor and specify definition elements for
    # the request. The Source element must have the following sub-elements:
    #   * RequestorID
    #   * RequestorPreferences
    #
    # This function is used to construct the Source XML
    def source_xml
      %Q(
        <Source>
          <RequestorID Client="#{self.client_id}" EMailAddress="#{self.email}" Password="#{self.password}" />
          <RequestorPreferences>
            <RequestMode>#{self.request_mode}</RequestMode>
            #{self.request_mode == GtaConstant::REQUEST_MODE::ASYNCHRONOUS ? "<ResponseURL>#{self.response_url}</ResponseURL>" : ''}
          </RequestorPreferences>
        </Source>
      ).strip
    end

    # Each request sent to the API must be contained within a Request element. The Request element itself must contain
    # the following two sub-elements:
    #   * Source
    #   * RequestDetails
    #
    # This function is used to construct the Request XML
    def request_xml(request_details_xml)
      %Q(
        <?xml version="1.0" encoding="UTF-8" ?>
        <Request>
          #{source_xml}
          <RequestDetails>
            #{request_details_xml}
          </RequestDetails>
        </Request>
      ).strip
    end

    # Sending GTA API request. This function requires GTA request details XML string.
    # This could be used to send API requests directly without using wrapper functions.
    #
    # @example simple request:
    #   GTAClient::Client.instance.request(xml_string)
    #
    # Some available data:
    #   * response.code
    #   * response.message
    #   * response.headers
    #   * response.body
    def request(request_details_xml, options = {})
      # This is default to SYNCHRONOUS request. Allow changing to ASYNCHRONOUS when needed
      if options[:request_mode].present?
        self.request_mode = options[:request_mode]
      end

      # Allow to specify a different callback URL
      if options[:response_url].present?
        self.response_url = options[:response_url]
      end

      body = request_xml(request_details_xml)
      puts body if options[:show_xml] == true # for debugging purpose
      return body if options[:return_xml] == true

      request_data = {
        :body => body,
        :headers => { 'Content-Type' => 'application/xml' },
        :ssl_version => :SSLv3,
        :timeout => options[:timeout] || 30
      }
      response = self.class.post(self.api_url, request_data)
      response
    end
  end
end
