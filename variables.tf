variable tenant_id {
  description = "Openstack Tenant ID Found in your openrc.sh file or Project > Compute API Access in the web GUI"
  default = "ENTER TENANT ID HERE"
  }

variable keypair_name {
  description = "Name of your keypair found in Project > Compute > Key Pairs in the Web GUI"
  default = "ENTER KEYPAIR NAME HERE"
}

variable auth_url {
  description = "Openstack authentication URL Found in your openrc.sh file or Project > Compute API Access > Identity in the web GUI"
  default = "ENTER AUTH URL HERE"
}