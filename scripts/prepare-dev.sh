#!/bin/bash

sudo apt-get install libmagic-dev

USER="ImageCropper"
PASS="ImageCropper"
DEVDB="\`image_cropper_development\`"
TESTDB="\`image_cropper_test\`"
HOST="'localhost'"

CMD1="GRANT USAGE ON *.* TO '$USER'@$HOST IDENTIFIED BY '$PASS';"
CMD2="GRANT ALL PRIVILEGES ON $DEVDB.* TO '$USER'@$HOST;"
CMD3="GRANT ALL PRIVILEGES ON $TESTDB.* TO '$USER'@$HOST;"
CMD4="FLUSH PRIVILEGES;"
CMDS="$CMD1$CMD2$CMD3$CMD4"

mysql -u $USER --password=${PASS} < /dev/null || {
  echo "Creating mysql user for project (need mysql root password)..."
  mysql -u root -p -e "$CMDS" || exit -1
}

