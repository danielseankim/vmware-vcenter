# Copyright (C) 2013 VMware, Inc.
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcenter')

Puppet::Type.type(:esx_rescanallhba).provide(:esx_rescanallhba, :parent => Puppet::Provider::Vcenter) do
  @doc = "Rescan all HBA"
  def create
    begin
      if host == nil
        raise Puppet::Error, "An invalid host name or IP address is entered. Enter the correct host name and IP address."
      else
        Puppet.notice "Re-Scanning for all HBAs."
        host.configManager.storageSystem.RescanAllHba()
        Puppet.notice "Re-Scanning for VMFS."
        host.configManager.storageSystem.RescanVmfs()
        Puppet.notice "Re-freshing Storage System."
        host.configManager.storageSystem.RefreshStorageSystem()
      end
    end
  rescue Exception => e
    fail "Unable to perform the operation because the following exception occurred: -\n #{e.message}"
  end

  def exists?
    return false
  end

  def destroy
  end

end

