#!/bin/bash

ADMIN_PASS=${MONGODB_ADMIN_PASS:-$(pwgen -s 12 1)}
USER_NAME=${MONGODB_USER_NAME:-app}
USER_PASS=${MONGODB_USER_PASS:-$(pwgen -s 12 1)}
USER_DB=${MONGODB_USER_DB:-app}
_word_admin=$( [ ${MONGODB_ADMIN_PASS} ] && echo "preset" || echo "random" )
_word_user=$( [ ${MONGODB_USER_PASS} ] && echo "preset" || echo "random" )

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating a user “admin” with a ${_word_admin} password in MongoDB"
mongo admin --eval "db.createUser({user: 'admin', pwd: '$ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"
echo "=> Creating a user “${USER_NAME}” with a ${_word_user} password in db “${USER_DB}” in MongoDB"
mongo admin -u admin -p $ADMIN_PASS  --eval "db.getSiblingDB('$USER_DB').createUser({user: '$USER_NAME', pwd: '$USER_PASS', roles:[{role:'dbOwner',db:'$USER_DB'}]});"
echo "=> Done!"
touch /data/db/.mongodb_password_set

echo "=========================================================================="
echo "You can now connect to this MongoDB server using:"
echo ""
echo "    mongo admin -u admin -p '$ADMIN_PASS' --host <host> --port <port>"
if [ ! ${MONGODB_ADMIN_PASS} ]; then
  echo "Please remember to change the admin password as soon as possible!"
fi
echo ""
echo "    mongo $USER_DB -u $USER_NAME -p '$USER_PASS' --host <host> --port <port>"
if [ ! ${MONGODB_USER_PASS} ]; then
  echo "Please remember to change the user password as soon as possible!"
fi
echo ""
echo "=========================================================================="
