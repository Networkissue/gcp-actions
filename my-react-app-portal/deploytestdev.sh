# #!/bin/bash
# echo "DEPLOYMENT OF MY-TEST-PORTAL FOR TEST-DEV ENVIRONMENT"

# set -a
# source environments/
# set +a

# VERSION="v$(date +%Y%m%d%H%M%S)"

# # Get script base path
# BASE_DIR="$(dirname "$0")"


# # Install dependencies

# git init

# npm install

# npm run build


# # ----------------------------------------
# # Deploy my-test-service
# echo "Deploying my-test-portal for $PROJECT_ID"

# # Merging portal and service into a single directory 'my-test-service'
# cd "$BASE_DIR"

# # Deploy the combined service
# gcloud config set project "$PROJECT_ID"
# # Comment out the next line if App Engine is already initialized
# # gcloud app create --region="$REGION" || true
# gcloud app deploy --project=$PROJECT_ID --version=$VERSION --quiet
# # gcloud app deploy --quiet

# # ----------------------------------------
# echo "✅ DEPLOYMENT FOR $PROJECT_ID IS DONE"



# ------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------


#!/bin/bash

set -e  # Exit on any error

# List of environments in order
environments=("dev" "qa" "stg" "prod")

for env in "${environments[@]}"
do
  echo ""
  echo "=========================================="
  echo "🚀 READY TO DEPLOY: $env"
  echo "=========================================="

  ENV_FILE="environments/.env.$env"

  if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Env file '$ENV_FILE' not found! Exiting..."
    exit 1
  fi

  # Ask user to confirm deployment
  read -p "👉 Do you want to deploy to '$env'? [y/N]: " confirm
#   confirm=${confirm,,}  # to lowercase #windows
  confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')


  if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "⛔ Deployment to $env cancelled. Exiting..."
    exit 1
  fi

  # Load env variables
  set -a
  source "$ENV_FILE"
  set +a

  # Set dynamic version
  VERSION="v$(date +%Y%m%d%H%M%S)"

  echo "🔧 Project: $PROJECT_ID"
  echo "🌍 Region: $REGION"
  echo "🏷️ Version: $VERSION"

  # Build app (optional per env)
  git init
  npm install
  npm run build

  # Deploy
  gcloud config set project "$PROJECT_ID"

  gcloud app create --region="$REGION" || true

  echo "🚢 Deploying to App Engine..."
  if gcloud app deploy app.yaml --version="$VERSION" --quiet; then
    echo "✅ Deployment to $env succeeded"
  else
    echo "❌ Deployment to $env failed. Exiting..."
    exit 1
  fi

done

echo ""
echo "🎉 Deployment script completed successfully!"
