$H = "Host: sklearn-iris.lab2.example.com"
# port-forward (another window): kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
curl.exe -s -H $H -H "Content-Type: application/json" http://localhost:8080/v1/models/sklearn-iris:predict -d "@iris-input.json"
curl.exe -s -H $H -H "Content-Type: application/json" http://localhost:8080/v2/models/sklearn-iris/infer -d "@iris-input-v2.json"
# load test
docker run --rm -v "${PWD}:/data" williamyeh/hey -z 30s -c 20 -m POST -host sklearn-iris.lab2.example.com -T "application/json" -D /data/iris-input.json http://host.docker.internal:8080/v1/models/sklearn-iris:predict
