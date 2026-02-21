

# after auth into the storage server, execute the following command
cd /usr/src/kodekloudrepos/demo
# Create a new branch devops in /usr/src/kodekloudrepos/demo repo  from master 
git switch -c devops master
# copy the /tmp/index.html file (present on storage  server itself) into the repo.
cp /tmp/index.html .
# add/commit this file in the new branch
git add index.html
git commit -m"Adding index.html the directory"
#  merge back that branch into master branch. 
git checkout master 
git merge devops
# push the changes to the origin for both of the branches.
git push origin master
git push origin devops