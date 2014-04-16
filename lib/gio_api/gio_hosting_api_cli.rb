require 'thor'
require 'pp'

module Gio
  def self.read_gio_api_keys(gio_hosting_api, access_key_file_path, secret_key_file_path)
    gio_hosting_api.read_access_key_file(access_key_file_path)
    gio_hosting_api.read_secret_key_file(secret_key_file_path)

    gio_hosting_api
  end

  def self.vm_stat_is_initialized_or_stopped?(gio_hosting_api, gp_service_code, gc_service_code)
    ret = gio_hosting_api.get_virtual_machine_status(gp_service_code: gp_service_code,
                                                     gc_service_code: gc_service_code)

    vm_stat = ret['GetVirtualMachineStatusResponse']['Status']
    if vm_stat == 'Initialized' or vm_stat == 'Stopped'
      true
    else
      false
    end
  end

  class HostingApiCli < Thor
    desc 'echo PARAMETER', 'echo the PARAMETER'
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    def echo(param)
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      pp gio_hosting_api.echo(param: param)
    end

    desc 'attach_vlan', "attach vlan to vm. "
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    options :gp_service_code => :required,
            :gc_service_code => :required,
            :gx_service_code => :required
    def attach_vlan()
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      if Gio::vm_stat_is_initialized_or_stopped?(gio_hosting_api, options[:gp_service_code], options[:gc_service_code])
        pp gio_hosting_api.attach_vlan(gp_service_code: options[:gp_service_code],
                                       gc_service_code: options[:gc_service_code],
                                       gx_service_code: options[:gx_service_code])
      else
        pp 'vm is running!'
      end
    end

    desc 'attach_fw_lb', "attach fw lb."
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    options :gp_service_code => :required,
            :gc_service_code => :required,
            :gl_service_code => :required
    def attach_fw_lb()
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      if Gio::vm_stat_is_initialized_or_stopped?(gio_hosting_api, options[:gp_service_code], options[:gc_service_code])
        pp gio_hosting_api.attach_fw_lb(gp_service_code: options[:gp_service_code],
                                        gc_service_code: options[:gc_service_code],
                                        gl_service_code: options[:gl_service_code])
      else
        pp 'vm is running!'
      end
    end

    desc 'import_root_ssh_public_key', "import root ssh public key to vm."
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    options :gp_service_code => :required,
            :gc_service_code => :required,
            :public_key => :required
    def import_root_ssh_public_key()
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      if Gio::vm_stat_is_initialized_or_stopped?(gio_hosting_api, options[:gp_service_code], options[:gc_service_code])
        pp gio_hosting_api.import_root_ssh_public_key(gp_service_code: options[:gp_service_code],
                                                      gc_service_code: options[:gc_service_code],
                                                      public_key: options[:public_key])
      else
        pp 'vm is running!'
      end
    end

    desc 'set_label', ''
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    options :gp_service_code => :required,
            :service_code    => :required,
            :label           => :required
    def set_label()
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      if Gio::vm_stat_is_initialized_or_stopped?(gio_hosting_api, options[:gp_service_code], options[:gc_service_code])
        pp gio_hosting_api.set_label(gp_service_code: options[:gp_service_code], service_code: options[:service_code], label: options[:label])
      else
        pp 'vm is running!'
      end
    end

    desc 'get_virtual_machine_status', ''
    option  :access_key_file_path, :default => '/root/.gio_access_key'
    option  :secret_key_file_path, :default => '/root/.gio_secret_key'
    options :gp_service_code => :required,
            :gc_service_code => :required
    def get_virtual_machine_status()
      gio_hosting_api = Gio::HostingApi.new
      gio_hosting_api = Gio::read_gio_api_keys(gio_hosting_api, options[:access_key_file_path], options[:secret_key_file_path])

      pp Gio::vm_stat_is_initialized_or_stopped?(gio_hosting_api, options[:gp_service_code], options[:gc_service_code])
    end
  end
end
