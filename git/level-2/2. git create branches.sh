# On Storage server in Stratos DC create a new branch xfusioncorp_ecommerce from master branch in /usr/src/kodekloudrepos/ecommerce git repo. 
ssh natasha@ststor01
cd /usr/src/kodekloudrepos/ecommerce
git switch -c xfusioncorp_ecommerce master
# or 
git checkout master
git checkout -b xfusioncorp_ecommerce