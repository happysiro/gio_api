require 'openssl'
require 'base64'
require 'cgi'
require 'time'
require 'net/http'
require 'net/https'
require 'json'

module Gio
  class HostingApi
    attr_accessor :api_version
    attr_accessor :api_host
    attr_accessor :api_path
    attr_accessor :expire
    attr_accessor :signature_method
    attr_accessor :signature_version
    attr_accessor :access_key_file_path
    attr_accessor :secret_key_file_path

    def initialize(api_host: 'gp.api.iij.jp', api_path: '/json', api_version: '20130901', expire: 300,  signature_method: 'HmacSHA256', signature_version: 2)
      @api_host          = api_host
      @api_path          = api_path
      @api_version       = api_version
      @expire            = expire
      @signature_method  = signature_method
      @signature_version = signature_version
    end

    def read_access_key_file(path='/root/.gio_access_key')
      open(path) do |gio_access_key|
          @access_key = (gio_access_key.read).chomp
      end
    end

    def read_secret_key_file(path='/root/.gio_secret_key')
      open(path) do |gio_secret_key|
        @secret_key = (gio_secret_key.read).chomp
      end
    end

    def method_missing(param, *args)
      call(param, *args)
    end

    private
    def call(action='echo', *args)
      params = {}

      args[0].each do |k, v|
        params[to_camel(k.to_s)] = v.to_s
      end

      params['Action']           = to_camel(action.to_s)
      params['AccessKeyId']      = @access_key
      params['SignatureVersion'] = @signature_version.to_s
      params['SignatureMethod']  = @signature_method
      params['APIVersion']       = @api_version
      params['Expire']           = (Time.now + @expire).utc.xmlschema

      sign_param = params.sort_by do |k, v|
        k
      end.map.each do |k, v|
        "#{escape(k)}=#{escape(v)}"
      end.join('&')

      params['Signature'] = signature(sign_param)
      req = Net::HTTP::Post.new(@api_path)
      req.set_form_data(params)
      http = Net::HTTP.new(@api_host, 443)
      http.use_ssl = true
      http.ca_path = nil
      http.ca_path = nil

      http.start do |conn|
        JSON.parse((http.request(req)).body)
      end
    end

    private
    def escape(str)
      CGI.escape(str).gsub('+', '%20').gsub('%7E', '~').gsub('=', '%3D')
    end

    private
    def signature(uri_param)
      string2sign = ''
      string2sign += "POST\n"
      string2sign += "#{@api_host}\n"
      string2sign += "#{@api_path}\n"
      string2sign += "#{uri_param}"
      secret_key  =  @secret_key
      sign = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, secret_key, string2sign)
      Base64.encode64(sign).chomp
    end

    private
    def to_camel(str)
      str.split('_').collect {|v| v.capitalize}.join
    end

  end
end
