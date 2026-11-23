# MLOps Lab 2: Serving Models with KServe
Environment: kind + KServe v0.17.1 (Serverless / Knative + Istio), Windows PowerShell

| File | Purpose |
|---|---|
| sklearn-iris.yaml | Step 1: InferenceService (model v1) |
| canary.yaml | Step 2: model-2 with canaryTrafficPercent: 20 |
| promote.yaml | Step 2: promote model-2 to 100% |
| autoscale.yaml | Step 3: minReplicas 1, maxReplicas 5, concurrency target 2 |
| iris-input.json / iris-input-v2.json | V1 / V2 protocol request bodies |
| test-commands.ps1 | V1, V2 inference + hey load test |
| canary-test.ps1 | 20 requests + count per revision |

Screenshots: see screenshots/ (1 isvc READY=True, 2 V1/V2 predictions, 3 canary 16:4 split, 4 autoscaling 1 to 5 pods)

Note: default model resources (1 CPU / 2Gi) left the canary pod Pending on kind, so requests were lowered to 100m / 256Mi.
