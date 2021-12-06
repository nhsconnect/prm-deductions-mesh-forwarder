environment    = "test"

service_desired_count = "1"
cloudwatch_alarm_evaluation_periods = 5
poll_frequency = "10"

mesh_url = "https://msg.intspineservices.nhs.uk"
mesh_mailbox_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-id "
mesh_password_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-password"
mesh_shared_key_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-shared-secret"
mesh_client_cert_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-client-cert"
mesh_client_key_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-client-key"
mesh_ca_cert_ssm_param_name = "/repo/test/user-input/external/mesh-mailbox-ca-cert"

alarm_sns_arn = "arn:aws:sns:eu-west-2:005235525306:test-alarm-notifications-sns-topic"