[
    {
        "name": "${app_name}", 
        "image": "${app_image}", 
        "portMappings": [
            {
                "containerPort": ${container_port}, 
                "hostPort": ${host_port}, 
                "protocol": "${app_protocol}"
            }
        ], 
        "essential": true, 
        "cpu": ${app_cpu},
        "memory": ${app_memory},
        "entryPoint": [
            "powershell",
            "-Command"
        ], 
        "command": [
            "New-Item -Path C:\\inetpub\\wwwroot\\index.html -ItemType file -Value '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p>' -Force ; C:\\ServiceMonitor.exe w3svc"
        ],

        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-stream-prefix": "${stream_prefix}",
                "awslogs-region": "${region}"
            }
        }   
    }
]