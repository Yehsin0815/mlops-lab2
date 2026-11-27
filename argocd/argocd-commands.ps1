# Bonus 2: install Argo CD and let it sync gitops/sklearn-iris.yaml
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait -n argocd --for=condition=Available deploy --all --timeout=600s
kubectl apply -f argocd/application.yaml
kubectl get applications -n argocd
kubectl get isvc -n lab2-gitops
# UI (another window): kubectl port-forward -n argocd svc/argocd-server 8443:443  -> https://localhost:8443  user: admin
$p = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))
