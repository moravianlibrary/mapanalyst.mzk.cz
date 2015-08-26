all: build

build:
	docker build -t mapanalyst .

run:
	-docker rm mapanalyst
	docker run -i -t -p 9001:8080 --name mapanalyst mapanalyst
