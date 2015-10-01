.PHONY: build run-development run-development-noinit run
.DEFAULT_GOAL: run-development

build:
	docker build --rm=true -t databox/tube2tube .

run-development:
	docker run -h tube2tube \
		--name tube2tube \
		--dns=10.240.218.252 \
		--link=beanstalkd:beanstalkd \
		-e NODE_ENV=development \
		-v `pwd`/./:/home/app/tube2tube \
		--rm -ti databox/tube2tube

run-development-noinit:
	docker run -h tube2tube \
		--name tube2tube \
		--dns=10.240.218.252 \
		--link=beanstalkd:beanstalkd \
		-e NODE_ENV=development \
		-v `pwd`/./:/home/app/tube2tube \
		--rm -ti databox/tube2tube \
		bash -l