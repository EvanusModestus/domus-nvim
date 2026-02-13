#!/bin/bash
set -e

cd "$(dirname "$0")/docs"

case "${1:-build}" in
    build)
        npx antora antora-playbook.yml
        echo "Site built: docs/build/site/index.html"
        ;;
    serve)
        npx antora antora-playbook.yml
        cd build/site && python3 -m http.server 8000
        ;;
    open)
        npx antora antora-playbook.yml
        xdg-open build/site/index.html
        ;;
    clean)
        rm -rf build
        echo "Cleaned build directory"
        ;;
    *)
        echo "Usage: $0 {build|serve|open|clean}"
        exit 1
        ;;
esac
