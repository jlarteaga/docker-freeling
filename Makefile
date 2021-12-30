image_name:=jlarteaga/freeling
version:=0.0.0

build:
	docker build -t $(image_name):$(version) .

publish:
	docker push $(image_name):$(version)
