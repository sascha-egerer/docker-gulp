CONTAINER_NAME_STYLEGUIDE=my-project-styleguide
CONTAINER_NAME_REGRESSION_TEST=my-project-regression-test
IMAGE_NAME=myvendor/styleguide
STYLEGUIDE_PORT=3000

MAKEFILE_DIR=$(shell dirname $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH=$(realpath $(MAKEFILE_DIR)/../../../../.. )
RESOURCE_PRIVATE_PATH=$(PROJECT_PATH)/Resources/Private
GEMINI_REPORT_DIR=$(RESOURCE_PRIVATE_PATH)/gemini-report

arg_section=$(section)
ifdef section
STYLEGUIDE_SECTION=--section $(section)
else
STYLEGUIDE_SECTION=
endif

base:
	docker build --rm -t $(IMAGE_NAME)-base --no-cache -f Dockerfile-base $(PROJECT_PATH)/Resources

update:
	docker build --rm -t $(IMAGE_NAME) -f Dockerfile $(PROJECT_PATH)/Resources

test:
	make update
	- rm -Rf $(GEMINI_REPORT_DIR)
	- make test-abort
	docker run --rm --name=$(CONTAINER_NAME_REGRESSION_TEST) -v $(PROJECT_PATH)/Resources/Private/Build/Tests:/frontend/Private/Build/Tests -v $(GEMINI_REPORT_DIR):/frontend/Private/gemini-report -t -e START_STYLEGUIDE=1 $(IMAGE_NAME) gulp tests:visual:test $(STYLEGUIDE_SECTION)
	- open $(PROJECT_PATH)/Resources/Private/gemini-report/index.html

test-update:
	make update
	- make test-abort
	docker run --rm --name=$(CONTAINER_NAME_STYLEGUIDE) -v $(PROJECT_PATH)/Resources/Private/Build/Tests:/frontend/Private/Build/Tests -v $(GEMINI_REPORT_DIR):/frontend/Private/gemini-report -t -e START_STYLEGUIDE=1 $(IMAGE_NAME) gulp tests:visual:update $(STYLEGUIDE_SECTION)

test-abort:
	- docker stop $(CONTAINER_NAME_REGRESSION_TEST)
	- docker rm $(CONTAINER_NAME_REGRESSION_TEST)
