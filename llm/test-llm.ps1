# Bonus 1: deploy the LLM and call the OpenAI-compatible chat completions endpoint
kubectl apply -n lab2 -f llm/qwen-llm.yaml
kubectl get isvc qwen-llm -n lab2 -w          # wait for READY=True (first time: image pull + model download), then Ctrl+C
# another window: kubectl port-forward -n lab2 svc/qwen-llm-predictor 8081:80
curl.exe -s -H "Content-Type: application/json" http://localhost:8081/openai/v1/chat/completions -d "@llm/chat-request.json"
