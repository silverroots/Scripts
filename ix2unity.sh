pushd /projects/cmake_xcode_projects
cmake_gen_xcode.py launcher --macos
xcodebuild -project macOS/launcher/MacOS-ixengine.xcodeproj -target ixengine
rm -rfv "/projects/ixengine/urd/Assets/Plugins/ixengine_d.bundle*"
cp -av "/projects/cmake_xcode_projects/macOS/launcher/games/_ix/osx_bundle/Debug/ixengine_d.bundle" "/projects/ixengine/urd/Assets/Plugins/ixengine_d.bundle"
popd
