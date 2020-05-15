.PHONY: all build dist clean

uid := ${shell id -u ${USER}}
gid := ${shell id -g ${USER}}

all: dist

container:
	docker build --tag lambda-builder .

build: container
	docker run -v ${PWD}:/build lambda-builder npm install --production
	docker run --rm -v ${PWD}:/build lambda-builder chown -R ${gid}:${gid} node_modules package-lock.json

dist: build
	zip -FS -q -r dist/lambda_resize.zip node_modules index.js package.json package-lock.json

clean:
	rm -rf node_modules dist/lambda_resize.zip || True
	docker rmi -f lambda-builder
