all: build

build:
	docker build -t mapanalyst .

run:
	docker run -i -t -p 9001:8080 mapanalyst
