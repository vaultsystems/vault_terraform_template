################################################################
################################################################
################################################################
# This is a example of a basic Terraform configuration using an 
# Openstack provider for Vault Secure cloud offering. All content 
# here is inteneded for educational purposes and is to be reviewed
# before use in a production scenario.
################################################################
################################################################
################################################################

################################################################
#AUTHENTICATION
################################################################
provider "openstack" {
  auth_url  = "${var.auth_url}"
  tenant_id = "${var.tenant_id}"
  version = "1.19.0"
}

################################################################
#STATE FILE STORAGE
################################################################

# Store state file to object storage (Swift)

terraform {
  backend "swift" {
    container         = "terraform-state"
    archive_container = "terraform-state-archive"
  }
}
################################################################
#SECURITY GROUPS
################################################################

#default security group
resource "openstack_compute_secgroup_v2" "demo_default_secgroup" {
  name        = "demo_default_secgroup"
  description = "demo Security Group"

  #allow ICMP (Ping) traffic
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  #allow SSH traffic
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  #allow Web traffic
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  #allow SSL traffic
  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  #allow DNS traffic
  rule {
    from_port   = 53
    to_port     = 53
    ip_protocol = "udp"
    cidr        = "0.0.0.0/0"
  }
}


###############################################################
#NETWORK CREATION
###############################################################

#Create network and Subnet
resource "openstack_networking_network_v2" "example_network" {
  name           = "example_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "example_subnet" {
  name       = "example_subnet"
  network_id = "${openstack_networking_network_v2.example_network.id}"
  cidr       = "10.31.10.0/24"
  ip_version = 4
}

################################################################
#STORAGE VOLUME CREATION
################################################################

# Creating a 100GB volume on Vault Tier 2 storage
resource "openstack_blockstorage_volume_v3" "demo_volume" {
  name  = "demo_volume"
  size  = 100
  volume_type = "TIER2"

# allow volume to be deleted when instance is deleted.    
  lifecycle {
    prevent_destroy = false
  }
}

################################################################
#STORAGE VOLUME ATTACH
################################################################

#attach Volume to an instance
resource "openstack_compute_volume_attach_v2" "demo_volume_attach" {
  instance_id = "${openstack_compute_instance_v2.demo_instance.id}"
  volume_id   = "${openstack_blockstorage_volume_v3.demo_volume.id}"
}

################################################################
#COMPUTE CREATION
################################################################

# Example of a single instance deploy
resource "openstack_compute_instance_v2" "demo_instance" {
  name            = "demo_instance"
  image_name      = "CentOS 7"
  flavor_name     = "4C16R64D"
  key_pair        = "${var.keypair_name}"
  security_groups = ["${openstack_compute_secgroup_v2.demo_default_secgroup.name}"]
  depends_on = ["openstack_networking_subnet_v2.example_subnet"]

  network {
    name        = "example_network"
    fixed_ip_v4 = "10.31.10.148"
  }

# Lifecycle ignore_change prevents instance termination due to an image name change
  lifecycle {
    ignore_changes = ["image_name"]
  }
}

