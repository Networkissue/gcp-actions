cd ..
cd ..
echo "DEPLOYMENT OF NODE SERVICE"
cd my-node-app-service

git init

echo Reverting all local changes
# git stash

echo replace dev instances with qa instances in app.yaml
#!/bin/bash

# Check if app.yaml exists
if [ ! -f app.yaml ]; then 
    echo "app.yaml not found"
    exit 1
else 
    # Check the operating system and adjust sed syntax accordingly
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (uses -i '')
        sed -i '' '/service_account: test-dev-4321@test-dev-4321.iam.gserviceaccount.com/s/.*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
        sed -i '' '/  DEPLOYMENT: "dev"/s/.*/  DEPLOYMENT: "qa"/' environments.js
    else
        # Linux (uses -i without '')
        sed -i '/service_account: test-dev-4321@test-dev-4321.iam.gserviceaccount.com/s/.*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
        sed -i '/  DEPLOYMENT: "dev"/s/.*/  DEPLOYMENT: "qa"/' environments.js
    fi
fi



echo install npm packages
npm install
echo set cloud account
gcloud auth application-default set-quota-project '{{ secrets.QA_ID }} '
# gcloud config set project '{{ secrets.QA_ID }} '
# echo deploy service to appengine
# gcloud app deploy --quiet
# echo deploy service to appengine is done

echo Reverting all QA deployment changes
# git stash
# git add .
# git stash

echo DEPLOYMENT OF NODE SERVICE

# ------------------------------------------------------------
# ------------------------------------------------------------

cd ..
echo "DEPLOYMENT OF REACT PORTAL"
cd my-react-app-portal

echo Reverting all local changes
# git stash

echo replace dev instances with qa instances in app.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/^service_account: .*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
    sed -i '' 's/DEPLOYMENT: .*/DEPLOYMENT: "qa",/' app.yaml
    sed -i '' 's/DEPLOYMENT: .*/DEPLOYMENT: "qa",/' environment.js
    sed -i '' "s/\(    NODE_URL: \).*/\1\"$DEMO_URL\",/" environment.js
    sed -i '' "s/\(    REACT_URL: \).*/\1\"$DEMO_URL\",/" environment.js
else
    # Linux version (as above)
    sed -i 's/^service_account: .*/service_account: test-qa-4321@test-qa-4321.iam.gserviceaccount.com/' app.yaml
    sed -i 's/DEPLOYMENT: .*/DEPLOYMENT: "qa",/' app.yaml
    sed -i 's/DEPLOYMENT: .*/DEPLOYMENT: "qa",/' environment.js
    sed -i "s/\(    NODE_URL: \).*/\1\"$DEMO_URL\",/" environment.js
    sed -i "s/\(    REACT_URL: \).*/\1\"$DEMO_URL\",/" environment.js
fi




echo install npm packages
npm install
echo prepare build
npm run build 
echo set cloud account
gcloud config set project test-qa-4321
# echo deploy portal to appengine
# gcloud app deploy --quiet
# echo deploy portal to appengine is done

# echo Reverting all QA deployment changes
# git stash

# echo DEPLOYMENT of QA portal is done

cd ..
cd Installer
# echo deployment is done
