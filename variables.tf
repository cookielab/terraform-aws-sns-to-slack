variable "topic_name" {
  type    = string
  default = null
}

variable "topic_policy" {
  type    = string
  default = null
}

variable "slack_webhook" {
  type = string
}

variable "slack_username" {
  type = string
}

variable "slack_channel" {
  type = string
}

variable "lambda_name" {
  type    = string
  default = null
}
