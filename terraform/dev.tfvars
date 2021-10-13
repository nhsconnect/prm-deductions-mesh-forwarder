environment    = "dev"

service_desired_count = "1"

poll_frequency = "10"

task_cpu    = 256
task_memory = 512

message_destination = "sns"

mesh_url = "https://msg.intspineservices.nhs.uk"
mesh_mailbox_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-id"
mesh_password_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-password"
mesh_shared_key_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-shared-secret"
mesh_client_cert_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-client-cert"
mesh_client_key_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-client-key"
mesh_ca_cert_ssm_param_name = "/repo/dev/user-input/external/mesh-mailbox-ca-cert"

