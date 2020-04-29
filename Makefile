NAME    := peopleperhour/clam
TAG=$(shell cat * | md5sum | cut -c1-8)

container:
	docker build -t ${NAME}:${TAG} .
# use `make push-test` to avoid updating latest (useful for testing on staging)
push-test:
	@echo "The CHECKSUM of all files in this folder is ${TAG}."
	@echo "Pushing to Docker Hub..."
	docker push ${NAME}:${TAG}