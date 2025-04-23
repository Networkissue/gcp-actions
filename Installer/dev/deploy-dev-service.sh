echo "DEPLOYMENT OF NODE SERVICE"
cd ..
cd ..
cd my-node-app-service

echo Reverting all local changes
git stash
if [[ $# -eq 0 ]] || [[ $1 == "" ]]; then
    VERSION_STRING='"version": '
    CURR_VERSION=$(awk -F \" '/"version": ".+"/ { print $4; exit; }' package.json)
    NEXT_VERSION=$(echo ${CURR_VERSION} | awk -F. -v OFS=. '{$NF += 1 ; print}')
    sed -i '' "s/\($VERSION_STRING\).*/\1\"$NEXT_VERSION\",/" package.json
    echo $NEXT_VERSION

    git commit -m "Create new build ${NEXT_VERSION}" -a
    # git push origin
else
    CURR_VERSION=$(awk -F \" '/"version": ".+"/ { print $4; exit; }' package.json)
    echo $CURR_VERSION
    sed -i '' '/version/s/[^.]*$/'"$1\",/" package.json

    git commit -m "Create new build 1.0.$1" -a
    # git push origin
fi

npm install
npm run build 
gcloud auth application-default set-quota-project test-dev-4321
gcloud config set project test-dev-4321
gcloud app deploy --quiet

echo """ """ """ """ """ """ """ """

echo DEPLOYMENT OF  of Node Service is done

echo """ """ """ """ """ """ """ """

cd ..
cd Installer