# pcli_base build

```console
$Env:TAG = "0.2"
docker build -t pcli-base:$Env:TAG .

docker image tag pcli-base:$Env:TAG bsabol127/pcli-base:$Env:TAG
docker push bsabol127/pcli-base:$Env:TAG
```
# pcli-base
