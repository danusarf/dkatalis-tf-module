resource "aws_iam_instance_profile" "ec2-master" {
  name = "${local.es_master_name}-instance-role"
  role = aws_iam_role.ec2-master.name
}

resource "aws_iam_policy" "ec2-master" {
  name        = "${local.es_master_name}-role-policy"
  description = "IAM policy for DKatalis Elasticsearch cluster master"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SecretsManagerAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:CancelRotateSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:UpdateSecret",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:StopReplicationToReplica",
          "secretsmanager:ReplicateSecretToRegions",
          "secretsmanager:RestoreSecret",
          "secretsmanager:RotateSecret",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:RemoveRegionsFromReplication"
        ]
        Resource = "arn:aws:secretsmanager:us-east-1:466123950281:secret:elasticsearch/initial-credentials/${local.env}-dkatalis-es-cluster*"
      },
      {
        Sid = "SecretsManagerListAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2-master" {
  name = "ec2-${local.es_master_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-master-attach-1" {
  role       = aws_iam_role.ec2-master.name
  policy_arn = aws_iam_policy.ec2-master.arn
}
resource "aws_iam_role_policy_attachment" "ec2-master-attach-2" {
  role       = aws_iam_role.ec2-master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "ec2-master-attach-3" {
  role       = aws_iam_role.ec2-master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}