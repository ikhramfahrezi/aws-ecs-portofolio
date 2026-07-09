# 1. Buat ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "flask-app-cluster"
}

# 2. IAM Role untuk ECS (Memberi izin ECS untuk mengambil image dari ECR)
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Tempelkan policy bawaan AWS untuk ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 3. Task Definition (Resep cara jalan container di AWS)
resource "aws_ecs_task_definition" "app_task" {
  family                   = "flask-app-task"
  network_mode             = "awsvpc" # Fargate butuh VPC
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"    # CPU terkecil (0.25 vCPU)
  memory                   = "512"    # Memori terkecil (0.5 GB)
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "flask-container"
      # Kita pakai dummy image dulu. Nanti GitHub Actions yang akan update dengan image aslinya
      image     = "nginx:latest" 
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}