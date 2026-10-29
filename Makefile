#!make
BUILDER ?= github
include Makefile.$(BUILDER)


build: build-date add-files-to-archive docker-lab-html

.PHONY: fetch-anchor-sources help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy deploy-lab deploy-lms

add-files-to-archive:
	cp -r labs/* build
	$(MAKE) fetch-anchor-sources
	for d in build/*; do \
	  [ -f $$d/WORKSHOP_ID ] || continue; \
	  tar -czvf build/`cat $$d/WORKSHOP_ID`.tar.gz -C $$d .; \
	done

	mkdir -p build/educates-resources
	cp -r resources/* build/educates-resources
	for f in build/educates-resources/apply/*; do \
	  VERSION=${version} CONTAINER_REGISTRY=${CONTAINER_REGISTRY} CONTAINER_REPOSITORY=${CONTAINER_REPOSITORY} envsubst '$${VERSION} $${CONTAINER_REGISTRY} $${CONTAINER_REPOSITORY}' < $$f > $$f.resolved; \
	  mv $$f.resolved $$f; \
	done

# The sample application is shipped as a git bundle (a single file, so it
# survives being unpacked as workshop files) and cloned by the lab's setup.d
# script, so sessions never need to reach GitHub.
fetch-anchor-sources:
	mkdir -p build/anchor/workshop/sources
	bash labs/anchor/workshop/scripts/prepare-petclinic.sh build/tmp-petclinic
	git -C build/tmp-petclinic bundle create $(CURDIR)/build/anchor/workshop/sources/spring-petclinic.bundle --all
	rm -rf build/tmp-petclinic

build-date:
	rm -rf build
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build
	date > build/build-date

docker-lab-html:

	docker build --build-arg VERSION="${version}" --build-arg IMAGE_SOURCE="${IMAGE_SOURCE}" \
				 -t "${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${env}" \
				 .

	docker image prune -f

docker-lab-html-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

release:
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest

deploy-lab:
	docker pull ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}

deploy-lms:
	metadata/lms/deploy.sh deploy-all

get-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

get-name:
	@echo "${NAME}"
