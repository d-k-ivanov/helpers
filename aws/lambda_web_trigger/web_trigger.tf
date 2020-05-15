data "template_file" "web_trigger_labmda_py" {
    template                = "${file("${path.module}/jobs/web_trigger.py")}"

    vars {
        url                 = "https://${var.dns_suffix}"
    }
}

data "archive_file" "web_trigger_labmda_zip" {
    type                    = "zip"
    output_path             = "${path.module}/output/web_trigger.zip"

    source {
        content             = "${data.template_file.web_trigger_labmda_py.rendered}"
        filename            = "web_trigger.py"
    }
}

resource "aws_lambda_function" "web_trigger_labmda" {
    description             = "function to trigger https://${var.dns_suffix}"
    filename                = "${path.module}/output/web_trigger.zip"
    function_name           = "${var.project_name}-${var.environment}-web-trigger"
    handler                 = "web_trigger.lambda_handler"
    role                    = "${aws_iam_role.iam_lambda_executor.arn}"
    runtime                 = "python3.6"
    source_code_hash        = "${data.archive_file.web_trigger_labmda_zip.output_base64sha256}"

    tags {
        Name                = "${var.project_name}-${var.environment}-labmda"
        Environment         = "${var.environment}"
        Project             = "${var.project_name}"
        Terraform           = "True"
    }
}

resource "aws_cloudwatch_event_rule" "web_trigger_event_rule" {
  name                      = "${var.project_name}-${var.environment}-web-trigger-event-rule"
  description               = "${var.project_name} ${var.environment} web trigger"
  schedule_expression       = "cron(30 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "web_trigger_event_target" {
  target_id                 = "${var.project_name}-${var.environment}-web-trigger-lambda"
  rule                      = "${aws_cloudwatch_event_rule.web_trigger_event_rule.name}"
  arn                       = "${aws_lambda_function.web_trigger_labmda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id              = "AllowExecutionFromCloudWatch"
  action                    = "lambda:InvokeFunction"
  function_name             = "${aws_lambda_function.web_trigger_labmda.arn}"
  principal                 = "events.amazonaws.com"
  source_arn                = "${aws_cloudwatch_event_rule.web_trigger_event_rule.arn}"
}
