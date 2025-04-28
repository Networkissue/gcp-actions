echo "DEPLOYMENT OF REACT PORTAL"
cd ..
cd ..
cd my-react-app-portal

echo Reverting all local changes
git stash
if [[ $# -eq 0 ]] || [[ $1 == "" ]]; then
    VERSION_STRING='"version": '
    CURR_VERSION=$(awk -F \" '/"version": ".+"/ { print $4; exit; }' package.json)
    NEXT_VERSION=$(echo ${CURR_VERSION} | awk -F. -v OFS=. '{$NF += 1 ; print}')
    
    # Use the correct sed syntax based on the OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/\($VERSION_STRING\).*/\1\"$NEXT_VERSION\",/" package.json
    else
      sed -i "s/\($VERSION_STRING\).*/\1\"$NEXT_VERSION\",/" package.json
    fi
    
    echo $NEXT_VERSION
    git commit -m "Create new build ${NEXT_VERSION}" -a
    # git push origin
    else
    CURR_VERSION=$(awk -F \" '/"version": ".+"/ { print $4; exit; }' package.json)
    echo $CURR_VERSION
    sed -i '/version/s/[^.]*$/'"$1\",/" package.json
    git commit -m "Create new build 1.0.$1" -a
    # git push origin
    fi
    
    echo "new_version=${NEXT_VERSION}" >> $GITHUB_OUTPUT


npm install
npm run build 
# gcloud auth application-default login
# gcloud auth application-default set-quota-project '{{ secrets.DEV_ID }} '
# gcloud config set project '{{ secrets.DEV_ID }} '
# gcloud app deploy --quiet

echo """ """ """ """ """ """ """ """

echo React Portal

echo """ """ """ """ """ """ """ """

cd ..
cd Installer
