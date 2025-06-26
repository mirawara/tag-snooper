#!/bin/sh

crond -f -l 2 &

cp /opt/tagsnooper/repositories.txt /opt/tagsnooper/repositories_check.txt

sh /opt/tagsnooper/bin/check_tags.sh

/opt/tagsnooper/bin/watch_file.sh