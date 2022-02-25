<powershell>
$ECSCluster = "${ecs_cluster}"
Import-Module ECSTools
Initialize-ECSAgent -Cluster $ECSCluster -EnableTaskIAMRole -LoggingDrivers '["json-file","awslogs"]'
</powershell>