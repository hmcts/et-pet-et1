{{/*
base 1.4.1's library hardcodes an AKS agent-pool topology requirement.
Override the named helper from the temporary parent chart for this local run.
The shared base package and the checked-out ET1 chart remain untouched.
*/}}
{{- define "hmcts.topologySpreadConstraints.v1" }}
topologySpreadConstraints: []
{{- end }}
