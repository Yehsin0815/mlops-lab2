# MLOps Lab 2: Serving Models with KServe
Environment: kind + KServe v0.17.1 (Serverless / Knative + Istio), Windows PowerShell

Step 1 (install KServe on kind) was done with the KServe release-0.17 install scripts; the cloned `kserve/` folder is not committed (.gitignore).

| File | Purpose |
|---|---|
| sklearn-iris.yaml | Step 2: InferenceService (model v1), called with V1 and V2 protocol |
| canary.yaml | Step 3: model-2 with canaryTrafficPercent: 20 |
| promote.yaml | Step 3: promote model-2 to 100% |
| autoscale.yaml | Step 4: minReplicas 1, maxReplicas 5, concurrency target 2 |
| iris-input.json / iris-input-v2.json | V1 / V2 protocol request bodies |
| test-commands.ps1 | V1, V2 inference + hey load test |
| canary-test.ps1 | 20 requests + count per revision |

Screenshots (required part): see screenshots/ (1 isvc READY=True, 2 V1/V2 predictions, 3 canary 16:4 split, 4 autoscaling 1 to 5 pods, 5 revisions after promote/autoscale)

Note: default model resources (1 CPU / 2Gi) left the canary pod Pending on kind, so requests were lowered to 100m / 256Mi.

## Bonus 1: LLM Serving (Qwen2.5-0.5B-Instruct)

| File | Purpose |
|---|---|
| llm/qwen-llm.yaml | InferenceService with the KServe Hugging Face runtime, model `qwen` |
| llm/chat-request.json | OpenAI-style chat request body |
| llm/test-llm.ps1 | Deploy, port-forward, call `/openai/v1/chat/completions` |

```powershell
kubectl apply -n lab2 -f llm/qwen-llm.yaml
kubectl port-forward -n lab2 svc/qwen-llm-predictor 8081:80
curl.exe -s -H "Content-Type: application/json" http://localhost:8081/openai/v1/chat/completions -d "@llm/chat-request.json"
```

Fixes for a laptop kind cluster: `--backend=huggingface --dtype=float32` (no GPU, so no vLLM), and `deploymentMode: RawDeployment` for this model so the large image pull and model download are not cut off by Knative's revision deadline.

Screenshot: screenshots/6-llm-chat.png (isvc READY=True + chat completion response)

## Bonus 2: GitOps with Argo CD

| File | Purpose |
|---|---|
| gitops/sklearn-iris.yaml | InferenceService that lives in Git (deployed only by Argo CD) |
| argocd/application.yaml | Argo CD Application: watches `gitops/` on `main`, auto sync + self heal, namespace `lab2-gitops` |
| argocd/argocd-commands.ps1 | Install Argo CD, apply the Application, get the admin password |

Flow: install Argo CD, apply the Application, Argo CD creates `sklearn-iris` in `lab2-gitops` (Synced / Healthy). Then `minReplicas` was changed from 1 to 2 in Git only, and Argo CD synced the change automatically with no `kubectl apply`.

Server-side diff/apply is enabled so the fields KServe's webhook fills in do not show as OutOfSync.

Screenshots: screenshots/7-argocd-synced.png (Synced / Healthy, resource tree), screenshots/8-argocd-gitops-change.png (auto-synced to the new commit, rolling out), screenshots/9-argocd-2-pods.png (Synced / Healthy with 2 pods after the Git change)
