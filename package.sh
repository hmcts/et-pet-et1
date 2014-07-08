
if [ -n "$1" ]; then 
  export APPVERSION=`echo "$1" | sed -e "s/.*release\///g"`
else
  export APPVERSION='latest'
fi

DATE=`date`

cat <<EOT >MANIFEST
Version:  $APPVERSION
Date:     $DATE
BuildTag: $BUILD_TAG
Commit:   $GIT_COMMIT

EOT

# Generate a self contained bundle
#cd build
bundle \
       --path vendor/bundle \
       --deployment \
       --standalone \
       --binstubs \
       --without build


bundle exec rake assets:precompile RAILS_ENV=production

#export DOCKERTAG="${DOCKER_PREFIX}assets"
#echo "Building Assets Container ($APPVERSION)"
#./docker/assets/make.sh $APPVERSION

export DOCKERTAG="${DOCKER_PREFIX}rails"
echo "Building Rails Container ($APPVERSION)"
./docker/rails/make.sh $APPVERSION

