# tube2tube

[tube2tube](https://github.com/databox/tube2tube) will forward jobs from one
benstalkd to another bestanlkd according to [rules](config/development.json).

# Docker

    make build
    make run-development
    make run-development-noinit

## Development

    1. start beanstalkd docker instance...
    make build
    make run-development
    docker exec -ti tube2tube bash -lc \
        'cd /home/app/tube2tube && ./test_putjob.coffee beanstalkd:11300 conn_started "payload"'

## Production

    make build
	docker run \
	    -h tube2tube \
	    --restart=always \
		--name tube2tube \
		--dns=10.240.218.252 \
		-e NODE_ENV=production \
		-v `pwd`/./:/home/app/tube2tube \
		-ti databox/tube2tube
		
## Author

- [Oto Brglez](https://github.com/otobrglez)