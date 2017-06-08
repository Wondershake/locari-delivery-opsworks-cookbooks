::Chef::Recipe.send(:include, AddSecurityGroupHelper)

PUBLIC_IPADDRESS=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
TARGET_DB_SG="locari-delivery-v2"
RDS_SG_STATUS_FILE="/tmp/rds_security_group_status"

get_sts_info_helper

aws_access_key_id=aws_access_key_id_helper
aws_secret_access_key=aws_secret_access_key_helper
aws_security_token=aws_security_token_helper

execute "get rds security groupt status" do
  environment(
    "AWS_ACCESS_KEY_ID" => aws_access_key_id,
    "AWS_SECRET_ACCESS_KEY" => aws_secret_access_key,
    "AWS_SECURITY_TOKEN" => aws_security_token
  )
  cwd "/tmp"
  user "root"
  command <<-EOT
    aws rds describe-db-security-groups --db-security-group-name #{TARGET_DB_SG} --region ap-northeast-1 > #{RDS_SG_STATUS_FILE}
    cat #{RDS_SG_STATUS_FILE}
  EOT
end

execute "add security group" do
  environment(
    "AWS_ACCESS_KEY_ID" => aws_access_key_id,
    "AWS_SECRET_ACCESS_KEY" => aws_secret_access_key,
    "AWS_SECURITY_TOKEN" => aws_security_token
  )
  cwd "/tmp"
  user "root"
  command "aws rds authorize-db-security-group-ingress --db-security-group-name #{TARGET_DB_SG} --cidrip #{PUBLIC_IPADDRESS}/32 --region ap-northeast-1"
  not_if "cat #{RDS_SG_STATUS_FILE} | grep #{PUBLIC_IPADDRESS}"
end

file "#{RDS_SG_STATUS_FILE}" do
  action :delete
end

delete_sts_info_helper
