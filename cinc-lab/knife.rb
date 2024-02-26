current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'olit'
client_key               "#{current_dir}/olit.pem"
chef_server_url          'https://192.168.100.10/organizations/devix'
cookbook_path            "#{current_dir}/cookbooks"

ssl_verify_mode :verify_none

