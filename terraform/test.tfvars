environment    = "test"

service_desired_count = "1"

poll_frequency = 60

task_cpu    = 256
task_memory = 512

mesh_url="https://mesh.spineservices.nhs.uk"
mesh_mailbox_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-name"
mesh_password_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-password"
mesh_shared_key_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-shared-secret"
mesh_client_cert_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-client-cert"
mesh_client_key_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-client-key"
mesh_ca_cert_ssm_param_name="/repo/test/user-input/external/mesh-mailbox-ca-cert"