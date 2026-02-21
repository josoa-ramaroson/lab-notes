kubectl create namespace dev
kubectl run dev-nginx-pod -n dev --image=nginx:latest