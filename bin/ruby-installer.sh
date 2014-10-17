#!/bin/bash

# Install rbenv:
echo "Installing rbenv..."
git clone https://github.com/sstephenson/rbenv.git $RBENV_ROOT
echo "Done."

# Install plugins:
PLUGINS=(
  sstephenson/ruby-build
)

echo "Installing plugins..."
for plugin in ${PLUGINS[@]} ; do

  KEY=${plugin%%/*}
  VALUE=${plugin#*/}

  RBENV_PLUGIN_ROOT="${RBENV_ROOT}/plugins/$VALUE"
  if [ ! -d "$RBENV_PLUGIN_ROOT" ] ; then
    git clone https://github.com/$KEY/$VALUE.git $RBENV_PLUGIN_ROOT
  else
    cd $RBENV_PLUGIN_ROOT
    echo "Pulling $VALUE updates."
    git pull
  fi

done
echo "Done."

echo "gem: --no-rdoc --no-ri" > ${OPENSHIFT_DATA_DIR}.gemrc

echo '
if [ -d "${RBENV_ROOT}" ]; then
  eval "$(rbenv init -)"
fi

alias gem="gem --config-file ${OPENSHIFT_DATA_DIR}.gemrc"
' > $RBENV_INIT

source $RBENV_INIT

rbenv install $OPENSHIFT_RUBY_VERSION
rbenv global $OPENSHIFT_RUBY_VERSION

gem install bundler