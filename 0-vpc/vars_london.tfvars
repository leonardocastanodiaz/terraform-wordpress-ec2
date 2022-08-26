instance_ids = ([
    "i-09c866e56dfc946a8",
    "i-0623da49c14eda98b"
])


problematic_object = {
    src_port = 22
    dst_port = 22
    protocol = "tcp"
    prefix_list_name = ["web_dev_ip","web_prod_ip"]
}