#!/bin/sh

yum -y install firewalld
firewall-offline-cmd --zone=public --change-interface=docker0
systemctl start firewalld


# Docker image "jamesmontalvo3/meza-docker-test-max:latest" has mediawiki and
# several extensions pre-cloned, but not in the correct location. Move them
# into place. For some reason gives exit code 129 on Travis sometimes. Force
# non-failing exit code.
mkdir /opt/htdocs || true
mv /opt/mediawiki /opt/htdocs/mediawiki || true


# Install meza command
bash /opt/meza/src/scripts/getmeza.sh

# reset to no, in case follow on builds don't reset
is_minion=no


# -e: kill script if anything fails
# -u: don't allow undefined variables
# -x: debug mode; print executed commands
set -eux

echo "RUNNING TEST monolith-from-scratch"

fqdn="127.0.0.1"

# Since we want to make the monolith environment without prompts, need to do
# `meza setup env monolith` with values for required args included (fqdn,
# db_pass, email, private_net_zone).
meza setup env monolith --fqdn="${fqdn}" --db_pass=1234 --private_net_zone=public

echo "print hosts file"
cat /opt/conf-meza/secret/monolith/hosts

# Now that environment monolith is setup, deploy/install it
meza deploy monolith --no-firewall

# Need to sleep 10 seconds to let Parsoid finish loading
sleep 10s

# TEST BASIC SYSTEM FUNCTIONALITY
bash /opt/meza/tests/integration/server-check.sh

# Demo Wiki API test
bash /opt/meza/tests/integration/wiki-check.sh "demo" "Demo Wiki"
