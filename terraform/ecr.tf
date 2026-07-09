resource "aws_ecr_repository" "app_repo" {
  name                 = "flask-aws-app-repo"
  image_tag_mutability = "MUTABLE"

  # Agar image otomatis di-scan dari kerentanan keamanan (Security Best Practice)
  image_scanning_configuration {
    scan_on_push = true
  }
}