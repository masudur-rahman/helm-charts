{{/*
Expand the name of the chart.
*/}}
{{- define "expense-tracker-bot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "expense-tracker-bot.fullname" -}}
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
{{- define "expense-tracker-bot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "expense-tracker-bot.labels" -}}
helm.sh/chart: {{ include "expense-tracker-bot.chart" . }}
{{ include "expense-tracker-bot.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "expense-tracker-bot.selectorLabels" -}}
{{- $suffix := .suffix | default "" -}}
app.kubernetes.io/name: {{ include "expense-tracker-bot.name" . }}{{ $suffix }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "expense-tracker-bot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "expense-tracker-bot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "expense-tracker-bot.dbhost" -}}
{{- if .Values.database.deploy }}
{{- include "expense-tracker-bot.fullname" . }}-postgres.{{ .Release.Namespace }}.svc
{{- else }}
{{- .Values.database.postgres.host }}
{{- end }}
{{- end }}
