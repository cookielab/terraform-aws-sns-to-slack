variable "topic_name" {
  type    = string
  default = "sns-to-slack-topic"
}

variable "topic_policy" {
  type    = string
  default = null
}

variable "slack_webhook" {
  type = string
}

variable "slack_username" {
  type    = string
  default = null
}

variable "slack_channel" {
  type    = string
  default = null
}

variable "lambda_name" {
  type    = string
  default = null
}
