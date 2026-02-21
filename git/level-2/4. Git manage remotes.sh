# In /usr/src/kodekloudrepos/cluster repo add a new remote dev_cluster 
# and point it to /opt/xfusioncorp_cluster.git repository.
cd  /usr/src/kodekloudrepos/cluster
git remote add dev_cluster /opt/xfusioncorp_cluster.git

# b. There is a file /tmp/index.html on same server; 
# copy this file to the repo and add/commit to master branch.
cp /tmp/index.html .
git add index.html
git commit -m"Adding index.html the directory"
# c. Finally push master branch to this new remote origin.
git push dev_cluster master