.PHONY: build-and-push-docker-image build-docker-image tag-docker-image push-docker-image

# Set default TAG if not passed
TAG := $(or $(TAG),$(shell date +%Y%m%d%H%M))

build-docker-image:
	DOCKER_DEFAULT_PLATFORM="linux/amd64" docker build -t eopf-toolkit-dev .

tag-docker-image:
	docker tag eopf-toolkit-dev 4zm3809f.c1.de1.container-registry.ovh.net/eopf-toolkit-dev/eopf-toolkit-dev:$(TAG)

push-docker-image:
	docker push 4zm3809f.c1.de1.container-registry.ovh.net/eopf-toolkit-dev/eopf-toolkit-dev:$(TAG)

build-and-push-docker-image: build-docker-image tag-docker-image push-docker-image
	@echo "Docker image built and pushed with tag: $(TAG)"
