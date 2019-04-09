# Key pair
resource "aws_key_pair" "default" {
  key_name = "keypair"
  public_key = "${file("${var.key_path}")}"
}

# Create Web Instance
resource "aws_instance" "web" {
   ami  = "${var.ami}"
   instance_type = "t1.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.web-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.web.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("installweb.sh")}"

  tags {
    Name = "webserver"
  }
}
# Create DB Instance
resource "aws_instance" "db" {
   ami  = "${var.ami}"
   instance_type = "t1.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.db-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.db.id}"]
   source_dest_check = false
   user_data = "${file("installdb.sh")}"

  tags {
    Name = "database"
  }
}
