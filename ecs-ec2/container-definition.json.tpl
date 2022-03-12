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
            "C:\\ServiceMonitor.exe w3svc"
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
