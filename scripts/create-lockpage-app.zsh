#!/bin/zsh

set -ex

# Verify dependencies
if [ ! -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  echo "Run script in zsh to continue";
  return 1;
fi
if ! command -v rename &> /dev/null; then
  echo "Install $fg[cyan]rename$reset_color package to continue";
  return 1;
fi

# Get project name
NAME="my-app";
if [[ -z "$1" ]]; then
  read "project_name?$fg[cyan]?$reset_color What is your project named? $fg[cyan](my-app)$reset_color  ";
  if [[ ! -z "$project_name" ]]; then
    NAME="$project_name";
  fi
else
  NAME="$1";
fi

# Clone starter into project directory
mkdir "$NAME"
cd "$NAME"
git clone https://tw-space@github.com/tw-space/lockpage-starter-next .
rm -rf .git
git init

# Configure starter with project's name
perl -i -pe"s/lockpage\-starter\-next/$NAME/g" package.json
perl -i -pe"s/lockpage\-starter\-next/$NAME/g" appspec.yml
perl -i -pe"s/lockpage\-starter\-next/$NAME/g" scripts/start_server.sh
perl -i -pe"s/lockpage\-starter\-next/$NAME/g" scripts/populate_secrets.sh
perl -i -pe"s/my\-app/$NAME/g" .env/common.env.js
perl -i -pe"s/my\-app/$NAME/g" .env/RENAME_TO.secrets.js
perl -i -pe"s/my\-app/$NAME/g" cdk/package.json
rename "s/my\-app/$NAME/g" cdk/test/my-app-cdk.test.ts
perl -i -pe"s/my\-app/$NAME/g" cdk/lib/my-app-cdk-stack.ts
rename "s/my\-app/$NAME/g" cdk/lib/my-app-cdk-stack.ts
perl -i -pe"s/my\-app/$NAME/g" cdk/bin/my-app-cdk.ts
rename "s/my\-app/$NAME/g" cdk/bin/my-app-cdk.ts
perl -i -pe"s/my\-app/$NAME/g" cdk/cdk.json

# Success
echo ""
echo "Created new lockpage-full-stack-starter app $fg[green]$NAME$reset_color"
echo ""
echo "See $fg[green]README.md$reset_color for getting started"