resource_group_name = {
  location = "centralindia"
  name     = "sahithirg"
}
vnet = {
  address_space = ["192.168.0.0/16"]
  name          = "sahithivnet"
}
subnet = {
  names = [ "web","app" ]
}
linux_virtual_machine_name = {
  names = [ "sahithi","sahithi1" ]
}

