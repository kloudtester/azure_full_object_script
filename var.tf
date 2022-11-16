variable "resource_group_name" {
  type = object(
    {
      name     = string
      location = string
    }
  )

}
variable "vnet" {
  type = object(
    {
      name          = string
      address_space = list(string)

    }
  )

}
variable "subnet" {
  type = object(
    {
      names = list(string)

    }
  )

}
variable "linux_virtual_machine_name" {
      type = list(string)
  
}