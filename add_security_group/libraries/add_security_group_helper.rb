module AddSecurityGroupHelper

  def get_sts_info_helper
    target_role = "arn:aws:iam::529049444073:role/add_security_group_role"
    role_session_name = "AddSecurityGroupRoleSession"
    duration_second = 900

    %x{ aws sts assume-role --role-arn "#{target_role}" --role-session-name "#{role_session_name}" --duration-seconds #{duration_second} > /tmp/sts-assume-role }
  end

  def aws_access_key_id_helper
    %x{ cat /tmp/sts-assume-role | /tmp/jq -r ".Credentials .AccessKeyId" }.chop
  end

  def aws_secret_access_key_helper
    %x{ cat /tmp/sts-assume-role | /tmp/jq -r ".Credentials .SecretAccessKey" }.chop
  end

  def aws_security_token_helper
    %x{ cat /tmp/sts-assume-role | /tmp/jq -r ".Credentials .SessionToken" }.chop
  end

  def delete_sts_info_helper
    %x{ rm -f /tmp/sts-assume-role }
  end

end
