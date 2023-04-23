{{/*
Expand the name of the chart.
*/}}
{{- define "pawsitively-purrfect.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pawsitively-purrfect.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pawsitively-purrfect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pawsitively-purrfect.labels" -}}
helm.sh/chart: {{ include "pawsitively-purrfect.chart" . }}
{{ include "pawsitively-purrfect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pawsitively-purrfect.selectorLabels" -}}
{{- $suffix := .suffix | default "" -}}
app.kubernetes.io/name: {{ include "pawsitively-purrfect.name" . }}{{ $suffix }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "pawsitively-purrfect.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pawsitively-purrfect.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "postgres.host" -}}
{{ include "pawsitively-purrfect.fullname" . }}-postgres.{{ .Release.Namespace }}.svc
{{- end }}

{{- define "arangodb.host" -}}
{{ include "pawsitively-purrfect.fullname" . }}-arangodb.{{ .Release.Namespace }}.svc
{{- end }}

{{- define "grpc.host" -}}
{{ include "pawsitively-purrfect.fullname" . }}-grpc.{{ .Release.Namespace }}.svc
{{- end }}

{{- define "database.type" -}}
{{- if .Values.grpc.enabled -}} postgres {{- else -}} arangodb {{- end }}
{{- end }}

