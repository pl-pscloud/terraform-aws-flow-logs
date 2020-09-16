resource "aws_flow_log" "pscloud-flow-log" {
  iam_role_arn    = aws_iam_role.pscloud-iam-role-for-flow-log.arn
  log_destination = aws_cloudwatch_log_group.pscloud-cloudwatch-log-group.arn
  traffic_type    = var.pscloud_traffic_type //"ALL"
  vpc_id          = var.pscloud_vpc_id
  subnet_id       = var.pscloud_subnet_id
}

resource "aws_cloudwatch_log_group" "pscloud-cloudwatch-log-group" {
  name = var.pscloud_vpc_id != null ? "${var.pscloud_company}_flow_log_vpcId-${var.pscloud_vpc_id}_${var.pscloud_env}_${var.pscloud_project}" : "${var.pscloud_company}_flow_log_subnetId-${var.pscloud_subnet_id}_${var.pscloud_env}_${var.pscloud_project}"
}

resource "aws_iam_role" "pscloud-iam-role-for-flow-log" {
  name = "${var.pscloud_company}_iam_role_for_flow_log_${var.pscloud_env}_${var.pscloud_project}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "pscloud-iam-policy-for-cloudwatch-log" {

  name = "${var.pscloud_company}_iam_role_policy_for_cloudwatch_log_${var.pscloud_env}_${var.pscloud_project}"
  role = aws_iam_role.pscloud-iam-role-for-flow-log.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}