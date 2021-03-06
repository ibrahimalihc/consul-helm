#!/usr/bin/env bats

load _helpers

@test "client/SnapshotAgentDeployment: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "client/SnapshotAgentDeployment: enabled with client.snapshotAgent.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: enabled with client.enabled=true and client.snapshotAgent.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.enabled=true' \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: disabled with client=false and client.snapshotAgent.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.enabled=false' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

#--------------------------------------------------------------------
# tolerations

@test "client/SnapshotAgentDeployment: no tolerations by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.tolerations | length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "client/SnapshotAgentDeployment: populates tolerations when client.tolerations is populated" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.tolerations=allow' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.tolerations | contains("allow")' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

#--------------------------------------------------------------------
# priorityClassName

@test "client/SnapshotAgentDeployment: no priorityClassName by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.priorityClassName | length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "client/SnapshotAgentDeployment: populates priorityClassName when client.priorityClassName is populated" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.priorityClassName=allow' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.priorityClassName | contains("allow")' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

#--------------------------------------------------------------------
# global.bootstrapACLs and snapshotAgent.configSecret

@test "client/SnapshotAgentDeployment: no initContainer by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.initContainers' | tee /dev/stderr)
  [ "${actual}" = "null" ]
}

@test "client/SnapshotAgentDeployment: populates initContainer when global.bootstrapACLs=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.bootstrapACLs=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.initContainers | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: no volumes by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.volumes' | tee /dev/stderr)
  [ "${actual}" = "null" ]
}

@test "client/SnapshotAgentDeployment: populates volumes when global.bootstrapACLs=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.bootstrapACLs=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.volumes | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: populates volumes when client.snapshotAgent.configSecret.secretName and client.snapshotAgent.configSecret secretKey are defined" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.snapshotAgent.configSecret.secretName=secret' \
      --set 'client.snapshotAgent.configSecret.secretKey=key' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.volumes | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: no container volumeMounts by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.containers[0].volumeMounts' | tee /dev/stderr)
  [ "${actual}" = "null" ]
}

@test "client/SnapshotAgentDeployment: populates container volumeMounts when global.bootstrapACLs=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.bootstrapACLs=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.containers[0].volumeMounts | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: populates container volumeMounts when client.snapshotAgent.configSecret.secretName and client.snapshotAgent.configSecret secretKey are defined" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.snapshotAgent.configSecret.secretName=secret' \
      --set 'client.snapshotAgent.configSecret.secretKey=key' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.containers[0].volumeMounts | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

#--------------------------------------------------------------------
# nodeSelector

@test "client/SnapshotAgentDeployment: no nodeSelector by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.nodeSelector | length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "client/SnapshotAgentDeployment: populates nodeSelector when client.nodeSelector is populated" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'client.nodeSelector=allow' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.nodeSelector | contains("allow")' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

#--------------------------------------------------------------------
# global.tls.enabled

@test "client/SnapshotAgentDeployment: sets TLS env vars when global.tls.enabled" {
  cd `chart_dir`
  local env=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.tls.enabled=true' \
      . | tee /dev/stderr |
      yq -r '.spec.template.spec.containers[0].env[]' | tee /dev/stderr)

  local actual
  actual=$(echo $env | jq -r '. | select(.name == "CONSUL_HTTP_ADDR") | .value' | tee /dev/stderr)
  [ "${actual}" = 'https://$(HOST_IP):8501' ]

  actual=$(echo $env | jq -r '. | select(.name == "CONSUL_CACERT") | .value' | tee /dev/stderr)
  [ "${actual}" = "/consul/tls/ca/tls.crt" ]
}

@test "client/SnapshotAgentDeployment: populates volumes when global.tls.enabled is true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.tls.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.volumes | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: populates container volumeMounts when global.tls.enabled is true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.tls.enabled=true' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.containers[0].volumeMounts | length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "client/SnapshotAgentDeployment: can overwrite CA with the provided secret" {
  cd `chart_dir`
  local ca_cert_volume=$(helm template \
      -x templates/client-snapshot-agent-deployment.yaml  \
      --set 'client.snapshotAgent.enabled=true' \
      --set 'global.tls.enabled=true' \
      --set 'global.tls.caCert.secretName=foo-ca-cert' \
      --set 'global.tls.caCert.secretKey=key' \
      --set 'global.tls.caKey.secretName=foo-ca-key' \
      --set 'global.tls.caKey.secretKey=key' \
      . | tee /dev/stderr |
      yq '.spec.template.spec.volumes[] | select(.name=="consul-ca-cert")' | tee /dev/stderr)

  # check that the provided ca cert secret is attached as a volume
  local actual
  actual=$(echo $ca_cert_volume | jq -r '.secret.secretName' | tee /dev/stderr)
  [ "${actual}" = "foo-ca-cert" ]

  # check that it uses the provided secret key
  actual=$(echo $ca_cert_volume | jq -r '.secret.items[0].key' | tee /dev/stderr)
  [ "${actual}" = "key" ]
}
