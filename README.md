# Install RedisInsight on Kubernetes (GUI for Redis DB)

1. Download archive: 
```
wget https://docs.redis.com/latest/pkgs/redisinsight-chart-0.1.0.tgz
```
2. 
```
helm install redisinsight redisinsight-chart-0.1.0.tgz --set service.type=ClusterIP -n name_ns
```
3. 
```
kubectl --namespace name_ns port-forward deployment/redisinsight-redisinsight-chart 8001:8001
```
4. Open your browser and point to 
```
http://127.0.0.1:8001
```
5. Add new Redis DB, enter the following values:
    - Hostname: Example: dev.deps.epam.com
    - Port: NodePort svc redis
    - Name: Any
    - Password: ``` echo "Values.secrets_values.redis_password_secret" | base64 --decode ```
