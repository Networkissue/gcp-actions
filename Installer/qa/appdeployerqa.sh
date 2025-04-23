cd ..
cd ..
echo "DEPLOYMENT OF NODE SERVICE"
cd my-node-app-service

git init

echo Reverting all local changes
# git stash

echo replace dev instances with qa instances in app.yaml
if [ ! -f app.yaml ]; then 
    echo "app.yaml not found"
    exit 1
else 
    sed -i '' '/service_account: test-dev-4321@test-dev-4321.iam.gserviceaccount.com/s/.*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
    sed -i '' '/  DEPLOYMENT: "dev"/s/.*/  DEPLOYMENT: "qa"/' environments.js
fi


echo install npm packages
npm install
echo set cloud account
gcloud auth application-default set-quota-project test-qa-4321
gcloud config set project test-qa-4321
echo deploy service to appengine
gcloud app deploy --quiet
echo deploy service to appengine is done

echo Reverting all QA deployment changes
# git stash
# git add .
# git stash

echo DEPLOYMENT OF NODE SERVICE IS DONE

# ------------------------------------------------------------
# ------------------------------------------------------------

cd ..
echo "DEPLOYMENT OF REACT PORTAL"
cd my-react-app-portal

echo Reverting all local changes
# git stash

echo replace dev instances with qa instances in app.yaml
if [ ! -f app.yaml ]; then 
    echo "app.yaml not found"
    exit 1
else 
    # sed -i "" '/service: test-dev-4321/s/.*/service: test-qa-4321/' app.yaml
    sed -i '' 's/^service_account: .*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
    sed -i "" '/DEPLOYMENT: /s/.*/    DEPLOYMENT: "qa",/' app.yaml
    sed -i "" '/DEPLOYMENT: /s/.*/    DEPLOYMENT: "qa",/' environment.js
    DEMO_URL="https:\/\/my-test-service-dot-test-qa-4321.uc.r.appspot.com/"
    sed -i '' "s/\(    NODE_URL: \).*/\1\"$DEMO_URL\",/" environment.js

    DEMO_URL="https:\/\/my-test-portal-dot-test-qa-4321.uc.r.appspot.com/"
    sed -i '' "s/\(    REACT_URL: \).*/\1\"$DEMO_URL\",/" environment.js
fi



echo install npm packages
npm install
echo prepare build
npm run build 
echo set cloud account
gcloud config set project test-qa-4321
echo deploy portal to appengine
gcloud app deploy --quiet
echo deploy portal to appengine is done

echo Reverting all QA deployment changes
# git stash

echo DEPLOYMENT of QA portal is done

cd ..
cd Installer
echo deployment is done