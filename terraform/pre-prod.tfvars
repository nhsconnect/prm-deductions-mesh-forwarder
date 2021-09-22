environment    = "pre-prod"

service_desired_count = "2"

log_level = "info"

poll_frequency = 60

task_cpu    = 256
task_memory = 512

mesh_url="https://mesh.spineservices.nhs.uk"
mesh_mailbox_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-id"
mesh_password_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-password"
mesh_shared_key_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-shared-secret"
mesh_client_cert_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-client-cert"
mesh_client_key_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-client-key"
mesh_ca_cert_ssm_param_name="/repo/pre-prod/user-input/external/mesh-mailbox-ca-cert"