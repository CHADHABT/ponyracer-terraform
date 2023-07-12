[
  {
    "name": "ponyracer",
    "image": "${webapp_docker_image}",
    "cpu": 1,
    "memory": 512,
    "essential": true, 
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "command": [],
    "entryPoint": [],
    "links": [],
    "mountPoints": [],
    "volumesFrom": [],
    "environment": []
  }
]
