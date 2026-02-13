.PHONY: docs docs-serve clean

docs:
	cd docs && npx antora antora-playbook.yml

docs-serve: docs
	cd docs/build/site && python3 -m http.server 8000

docs-open: docs
	xdg-open docs/build/site/index.html

clean:
	rm -rf docs/build
