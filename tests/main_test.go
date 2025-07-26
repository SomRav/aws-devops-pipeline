package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsCodePipeline(t *testing.T) {
	t.Parallel()

	// AWS region where resources will be created
	awsRegion := "us-east-1"

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../terraform",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":       awsRegion,
			"project_name":     "test-dp",
			"github_owner":     "SomRav",
			"github_repo":      "aws-devops-pipeline",
			"github_token":     "dummy-token-for-testing",
			"allowed_ip_range": "10.0.0.0/16",
			"public_key":       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... dummy-key",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Test that the CodePipeline was created
	pipelineName := terraform.Output(t, terraformOptions, "pipeline_name")
	assert.Contains(t, pipelineName, "test-dp-pipeline")

	// Test that the S3 bucket was created
	bucketName := terraform.Output(t, terraformOptions, "s3_bucket_name")
	assert.Contains(t, bucketName, "test-dp-codepipeline-artifacts")

	// Verify the S3 bucket exists and is in the expected region
	aws.AssertS3BucketExists(t, awsRegion, bucketName)

	// Test that the ECR repository was created
	ecrRepoUrl := terraform.Output(t, terraformOptions, "ecr_repository_url")
	assert.Contains(t, ecrRepoUrl, "test-dp-app")

	// Test that the EC2 instance was created and is running
	terraform.Output(t, terraformOptions, "ec2_instance_id")
	aws.GetEc2InstanceIdsByTag(t, awsRegion, "Name", "test-dp-app-server")

	// Test that the CodeBuild project was created
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")
	assert.Equal(t, "test-dp-build", codebuildProjectName)

	// Test that the CodeDeploy application was created
	codedeployAppName := terraform.Output(t, terraformOptions, "codedeploy_application_name")
	assert.Equal(t, "test-dp-app", codedeployAppName)
}

func TestTerraformValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../terraform",
	})

	// Run terraform validate to check syntax
	terraform.Validate(t, terraformOptions)
}

func TestTerraformFormat(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../terraform",
	})

	// Run terraform fmt to check formatting
	terraform.RunTerraformCommand(t, terraformOptions, "fmt", "-check")
}
