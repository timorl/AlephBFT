#!/bin/sh
if [ -e `git diff HEAD~ src/` ]; then
 echo 'No changes in code.'
 exit 1
fi
if git diff HEAD~ Cargo.toml | grep -q '^+version ='; then
 echo 'Version has been bumped manually.'
 exit 1
fi
version=`grep -e '^version =' Cargo.toml | sed 's/version = //' | sed 's/"//g'`
major_version=`echo $version|grep -o -e '^[0-9]*'`
minor_version=`echo $version|grep -o -e '^[0-9]*.[0-9]*'|grep -o -e '[0-9]*$'`
patch_version=`echo $version|grep -o -e '[0-9]*$'`
new_version=$major_version.$minor_version.$((patch_version + 1))
sed -i "s/^version = \"$version\"$/version = \"$new_version\"/" Cargo.toml
git add Cargo.toml
git commit --amend --no-edit
