output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.app_pipeline.name
}

output "pipeline_url" {
  description = "URL of the CodePipeline"
  value       = "https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${aws_codepipeline.app_pipeline.name}/view"
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.app_build.name
}

output "codedeploy_application_name" {
  description = "Name of the CodeDeploy application"
  value       = aws_codedeploy_app.app.name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for artifacts"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "application_url" {
  description = "URL to access the deployed application"
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}
