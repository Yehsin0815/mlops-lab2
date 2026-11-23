$H = "Host: sklearn-iris.lab2.example.com"
kubectl get isvc -n lab2
1..20 | ForEach-Object { curl.exe -s -o NUL -H $H -H "Content-Type: application/json" http://localhost:8080/v1/models/sklearn-iris:predict -d "@iris-input.json" }
Start-Sleep 2
foreach ($r in "sklearn-iris-predictor-00001","sklearn-iris-predictor-00003") {
  $n = (kubectl logs -n lab2 -l serving.knative.dev/revision=$r -c kserve-container --since=30s --tail=-1 | Select-String "uvicorn.access.*predict").Count
  "$r : $n requests"
}
